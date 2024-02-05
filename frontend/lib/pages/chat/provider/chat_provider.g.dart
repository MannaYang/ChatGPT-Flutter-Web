// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tokenHash() => r'9bb74e050f6da3f02e20cad68d7a9e7da8ba065f';

///
/// Token Provider
///
///
/// Copied from [token].
@ProviderFor(token)
final tokenProvider = Provider<String>.internal(
  token,
  name: r'tokenProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tokenHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TokenRef = ProviderRef<String>;
String _$audioHash() => r'd65d1ba64bc1a15c2619a0eda954e8612ef71bd7';

///
/// Audio Players
///
///
/// Copied from [audio].
@ProviderFor(audio)
final audioProvider = Provider<AudioPlayer>.internal(
  audio,
  name: r'audioProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$audioHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AudioRef = ProviderRef<AudioPlayer>;
String _$streamControlHash() => r'ae9a45abd96eb899387a111e0695aa146cc873f0';

/// See also [streamControl].
@ProviderFor(streamControl)
final streamControlProvider =
    AutoDisposeProvider<StreamController<dynamic>>.internal(
  streamControl,
  name: r'streamControlProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$streamControlHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef StreamControlRef = AutoDisposeProviderRef<StreamController<dynamic>>;
String _$sendHash() => r'7a121a9b7080e0e22491bf4593cec0f8dbf2af8f';

///
/// Send Socket
///
///
/// Copied from [send].
@ProviderFor(send)
final sendProvider = AutoDisposeProvider<WebSocketChannel>.internal(
  send,
  name: r'sendProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sendHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SendRef = AutoDisposeProviderRef<WebSocketChannel>;
String _$receiveHash() => r'3c99ad5082f46db0bdd55afd64ade9f83d653a0c';

///
/// Receive Socket
///
///
/// Copied from [receive].
@ProviderFor(receive)
final receiveProvider = AutoDisposeProvider<WebSocketChannel>.internal(
  receive,
  name: r'receiveProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$receiveHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ReceiveRef = AutoDisposeProviderRef<WebSocketChannel>;
String _$sendStreamHash() => r'89ba545e610a19e0548c0aa41bf89c16a5c2ca67';

///
/// Chat Stream Response
///
///
/// Copied from [sendStream].
@ProviderFor(sendStream)
final sendStreamProvider =
    AutoDisposeStreamProvider<BaseResult<List<ChatMessageInfo>?>>.internal(
  sendStream,
  name: r'sendStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sendStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SendStreamRef
    = AutoDisposeStreamProviderRef<BaseResult<List<ChatMessageInfo>?>>;
String _$streamListenHash() => r'a35bdd99f9fb3cf4f812b7022beb5a7a97e52ffd';

/// See also [StreamListen].
@ProviderFor(StreamListen)
final streamListenProvider = AutoDisposeNotifierProvider<StreamListen,
    (int sendListen, int receiveListen)>.internal(
  StreamListen.new,
  name: r'streamListenProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$streamListenHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StreamListen
    = AutoDisposeNotifier<(int sendListen, int receiveListen)>;
String _$modalInputHash() => r'b21decf3f64e2e8cd479f1da2c6086d49b5af929';

/// See also [ModalInput].
@ProviderFor(ModalInput)
final modalInputProvider =
    AutoDisposeNotifierProvider<ModalInput, double>.internal(
  ModalInput.new,
  name: r'modalInputProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$modalInputHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ModalInput = AutoDisposeNotifier<double>;
String _$allowInputHash() => r'193f6138f2d9823da1de6c7c55f03fab93a427dc';

/// See also [AllowInput].
@ProviderFor(AllowInput)
final allowInputProvider =
    AutoDisposeNotifierProvider<AllowInput, bool>.internal(
  AllowInput.new,
  name: r'allowInputProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allowInputHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AllowInput = AutoDisposeNotifier<bool>;
String _$attachFileHash() => r'7b932f1074bd2cd6959885039c89d6d352864a1b';

/// See also [AttachFile].
@ProviderFor(AttachFile)
final attachFileProvider =
    AutoDisposeNotifierProvider<AttachFile, List<FileInfo>>.internal(
  AttachFile.new,
  name: r'attachFileProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$attachFileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AttachFile = AutoDisposeNotifier<List<FileInfo>>;
String _$allowRecordHash() => r'386921eafefd8af6d5689d97886a5278872381db';

/// See also [AllowRecord].
@ProviderFor(AllowRecord)
final allowRecordProvider =
    AutoDisposeNotifierProvider<AllowRecord, bool>.internal(
  AllowRecord.new,
  name: r'allowRecordProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allowRecordHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AllowRecord = AutoDisposeNotifier<bool>;
String _$chatConversationsHash() => r'e388da0d7fbfa83415b2a6a6d400597367002ab3';

/// See also [ChatConversations].
@ProviderFor(ChatConversations)
final chatConversationsProvider = AutoDisposeNotifierProvider<ChatConversations,
    (int, String, List<ChatConversationInfo>?)>.internal(
  ChatConversations.new,
  name: r'chatConversationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatConversationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChatConversations
    = AutoDisposeNotifier<(int, String, List<ChatConversationInfo>?)>;
String _$chatMessagesHash() => r'783b90022d344209d650d34b0d8bdace2d9ea39b';

/// See also [ChatMessages].
@ProviderFor(ChatMessages)
final chatMessagesProvider = AutoDisposeNotifierProvider<ChatMessages,
    (int, String, List<ChatMessageInfo>?)>.internal(
  ChatMessages.new,
  name: r'chatMessagesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatMessagesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChatMessages
    = AutoDisposeNotifier<(int, String, List<ChatMessageInfo>?)>;
String _$sendContentHash() => r'6917a7e2cffa0ce466a89d23f3988a573bd6a0c9';

/// See also [SendContent].
@ProviderFor(SendContent)
final sendContentProvider =
    AutoDisposeNotifierProvider<SendContent, double>.internal(
  SendContent.new,
  name: r'sendContentProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sendContentHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SendContent = AutoDisposeNotifier<double>;
String _$conversationSelectedHash() =>
    r'b5c1b88c5bb4d23a1ec729a05694562593ea1619';

/// See also [ConversationSelected].
@ProviderFor(ConversationSelected)
final conversationSelectedProvider = AutoDisposeNotifierProvider<
    ConversationSelected,
    (int conversationId, bool showInput, String rolePlay)>.internal(
  ConversationSelected.new,
  name: r'conversationSelectedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$conversationSelectedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ConversationSelected = AutoDisposeNotifier<
    (int conversationId, bool showInput, String rolePlay)>;
String _$settingMultiModalHash() => r'b864281a69d1c7ad8e460f8c72bc4946f2b495e7';

/// See also [SettingMultiModal].
@ProviderFor(SettingMultiModal)
final settingMultiModalProvider =
    AutoDisposeNotifierProvider<SettingMultiModal, int>.internal(
  SettingMultiModal.new,
  name: r'settingMultiModalProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settingMultiModalHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SettingMultiModal = AutoDisposeNotifier<int>;
String _$promptTemplateHash() => r'07b411f129b2ad300afca40651ac571d1b17345b';

/// See also [PromptTemplate].
@ProviderFor(PromptTemplate)
final promptTemplateProvider = NotifierProvider<PromptTemplate,
    (int, String, Map<String, String>)>.internal(
  PromptTemplate.new,
  name: r'promptTemplateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$promptTemplateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PromptTemplate = Notifier<(int, String, Map<String, String>)>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
