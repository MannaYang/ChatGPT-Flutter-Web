from enum import Enum

from langchain.agents import tool
from langchain.agents.agent_toolkits import (
    create_vectorstore_agent,
    VectorStoreToolkit,
    VectorStoreInfo,
)
from langchain.chains import RetrievalQA, ConversationChain
from langchain.memory import ConversationBufferMemory
from langchain_community.document_loaders import PyPDFLoader, UnstructuredWordDocumentLoader, TextLoader, \
    UnstructuredMarkdownLoader, UnstructuredFileLoader
from loguru import logger

from app.api.agent import vectorstore, llm, text_splitter, pinecone_index
from app.api.agent.redis_memory import RedisMemoryManager
from app.api.agent.role_play import rolePlayPromptManager


def create_file_vector(file_ext: str, file_path: str):
    if file_ext == "pdf":
        loader = PyPDFLoader(file_path)
    elif file_ext == "docx":
        loader = UnstructuredWordDocumentLoader(file_path)
    elif file_ext == "txt":
        loader = TextLoader(file_path)
    elif file_ext == "md":
        loader = UnstructuredMarkdownLoader(file_path)
    else:
        loader = UnstructuredFileLoader(file_path)
    documents = loader.load()
    texts = text_splitter.split_documents(documents)
    doc_ids = vectorstore.add_documents(texts)
    fetch_response = pinecone_index.fetch(ids=doc_ids)


def similarity_search(query: str, top_k: int = 1):
    docs = vectorstore.similarity_search(query, k=top_k)
    logger.info(f"Vectorstore search result: \n{docs}")
    return docs[0].page_content


def max_marginal_search(query: str, top_k: int = 1):
    docs = vectorstore.max_marginal_relevance_search(query, k=top_k)
    logger.info(f"Vectorstore search result: \n{docs}")
    return docs[0].page_content


@tool
def retrieval_qa(query: str):
    """
    Use this tool to query the Pinecone vector database and retrieve the document knowledge base
    through the LangChain RAG implementation to answer the question
    """
    qa = RetrievalQA.from_chain_type(
        llm=llm,
        chain_type="stuff",
        retriever=vectorstore.as_retriever(),
        tool_input=query
    )
    return qa.invoke(input={"input": query})


vectorstore_info = VectorStoreInfo(
    name="Retrieve the document knowledge",
    description="Use this tool to query the Pinecone vector database and retrieve the document knowledge base through "
                "the LangChain RAG implementation to answer the question",
    vectorstore=vectorstore
)

retrieval_agent_executor = create_vectorstore_agent(
    llm=llm,
    toolkit=VectorStoreToolkit(vectorstore_info=vectorstore_info),
    verbose=True
)


# retrieval_agent_executor = AgentExecutor(
#     agent=create_react_agent(llm, [retrieval_qa], agent_prompt),
#     tools=[retrieval_qa()],
#     verbose=True,
#     memory=agent_memory)


def agent_executor(query: str):
    output = retrieval_agent_executor.invoke({"input": query})
    return output["output"]


class RetrievalAgent(Enum):
    SIMILARITY_SEARCH = 3
    MAX_MARGINAL_SEARCH = 4
    AGENT_EXECUTOR = 5


# RAG Search
async def retrieval_agent(query: str, retrieval_type: int):
    type_value = int(retrieval_type)
    if type_value == RetrievalAgent.SIMILARITY_SEARCH.value:
        return similarity_search(query)
    elif type_value == RetrievalAgent.MAX_MARGINAL_SEARCH.value:
        return max_marginal_search(query)
    else:
        return agent_executor(query)


async def chain_invoke(inputs: str, session_id: int, role: str):
    prompt = rolePlayPromptManager.format_prompt(role=role)

    message_history = RedisMemoryManager.get_instance(RedisMemoryManager, session_id=str(session_id))
    memory = ConversationBufferMemory(chat_memory=message_history, return_messages=True)
    chain = ConversationChain(prompt=prompt, llm=llm, verbose=True, memory=memory)
    return chain.predict(input=inputs)
