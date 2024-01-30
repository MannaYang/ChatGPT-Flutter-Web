import os
import loguru
import openai
from dotenv import load_dotenv
from langchain.chains import ConversationChain
from langchain.memory import ConversationBufferWindowMemory
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.document_loaders import TextLoader
from langchain_openai import OpenAIEmbeddings, ChatOpenAI
from openai import AsyncOpenAI
from langchain_community.vectorstores import Pinecone as VectorPinecone
from pinecone import Pinecone, PodSpec

# load .env params
load_dotenv()

# openai
openai.log = "debug"
openai.api_key = os.environ["OPENAI_API_KEY"]

text_splitter = RecursiveCharacterTextSplitter(chunk_size=600, chunk_overlap=0.3,
                                               separators=["\n\n", "\n", " ", ""])
index_name = "ai-manna"

client = AsyncOpenAI()

embeddings = OpenAIEmbeddings()

llm = ChatOpenAI(temperature=0.7, model_name="gpt-3.5-turbo-1106",
                 max_tokens=1024, streaming=True, request_timeout=60, max_retries=1)

conversation_chain = ConversationChain(
    llm=llm,
    memory=ConversationBufferWindowMemory(k=10),
    verbose=True
)

agent_memory = ConversationBufferWindowMemory(
    memory_key='chat_history',
    k=5,
    return_messages=True
)

pc = Pinecone(api_key=os.getenv("PINECONE_API_KEY"), host=os.getenv("PINECONE_CONTROLLER_HOST"))
if index_name not in pc.list_indexes().names():
    loguru.logger.info(f"Creating index: {index_name}")
    loguru.logger.info(f"Store index: {pc.list_indexes()}")
    pc.create_index(name=index_name, metric="cosine", dimension=1536,
                    spec=PodSpec(os.getenv("PINECONE_ENV")))
    data_files = ["dart_v3.2.txt", "flutter_v3.16.txt", "langchain_v0.1.0.txt"]
    for file in data_files:
        file_content = TextLoader(f"./data/{file}").load()
        file_texts = text_splitter.split_documents(file_content)
        VectorPinecone.from_documents(file_texts, embeddings, index_name=index_name)
pinecone_index = pc.Index(index_name)
response = pinecone_index.describe_index_stats()
loguru.logger.info(f"Pinecone index created successfully.{response}")
vectorstore = VectorPinecone.from_existing_index(index_name, embeddings)
