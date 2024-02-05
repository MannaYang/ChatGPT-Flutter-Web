/// Generated file. Do not edit.
///
/// Original: assets/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 2
/// Strings: 114 (57 per locale)
///
/// Built on 2024-02-05 at 11:42 UTC

// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:slang/builder/model/node.dart';
import 'package:slang_flutter/slang_flutter.dart';
export 'package:slang_flutter/slang_flutter.dart';

const AppLocale _baseLocale = AppLocale.en;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en) // set locale
/// - Locale locale = AppLocale.en.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.en) // locale check
enum AppLocale with BaseAppLocale<AppLocale, Translations> {
	en(languageCode: 'en', build: Translations.build),
	zhCn(languageCode: 'zh', countryCode: 'CN', build: _StringsZhCn.build);

	const AppLocale({required this.languageCode, this.scriptCode, this.countryCode, required this.build}); // ignore: unused_element

	@override final String languageCode;
	@override final String? scriptCode;
	@override final String? countryCode;
	@override final TranslationBuilder<AppLocale, Translations> build;

	/// Gets current instance managed by [LocaleSettings].
	Translations get translations => LocaleSettings.instance.translationMap[this]!;
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
/// Configurable via 'translate_var'.
///
/// Usage:
/// String a = t.someKey.anotherKey;
/// String b = t['someKey.anotherKey']; // Only for edge cases!
Translations get t => LocaleSettings.instance.currentTranslations;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
/// String b = t['someKey.anotherKey']; // Only for edge cases!
class TranslationProvider extends BaseTranslationProvider<AppLocale, Translations> {
	TranslationProvider({required super.child}) : super(settings: LocaleSettings.instance);

	static InheritedLocaleData<AppLocale, Translations> of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context);
}

/// Method B shorthand via [BuildContext] extension method.
/// Configurable via 'translate_var'.
///
/// Usage (e.g. in a widget's build method):
/// context.t.someKey.anotherKey
extension BuildContextTranslationsExtension on BuildContext {
	Translations get t => TranslationProvider.of(this).translations;
}

/// Manages all translation instances and the current locale
class LocaleSettings extends BaseFlutterLocaleSettings<AppLocale, Translations> {
	LocaleSettings._() : super(utils: AppLocaleUtils.instance);

	static final instance = LocaleSettings._();

	// static aliases (checkout base methods for documentation)
	static AppLocale get currentLocale => instance.currentLocale;
	static Stream<AppLocale> getLocaleStream() => instance.getLocaleStream();
	static AppLocale setLocale(AppLocale locale, {bool? listenToDeviceLocale = false}) => instance.setLocale(locale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale setLocaleRaw(String rawLocale, {bool? listenToDeviceLocale = false}) => instance.setLocaleRaw(rawLocale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale useDeviceLocale() => instance.useDeviceLocale();
	@Deprecated('Use [AppLocaleUtils.supportedLocales]') static List<Locale> get supportedLocales => instance.supportedLocales;
	@Deprecated('Use [AppLocaleUtils.supportedLocalesRaw]') static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
	static void setPluralResolver({String? language, AppLocale? locale, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver}) => instance.setPluralResolver(
		language: language,
		locale: locale,
		cardinalResolver: cardinalResolver,
		ordinalResolver: ordinalResolver,
	);
}

/// Provides utility functions without any side effects.
class AppLocaleUtils extends BaseAppLocaleUtils<AppLocale, Translations> {
	AppLocaleUtils._() : super(baseLocale: _baseLocale, locales: AppLocale.values);

	static final instance = AppLocaleUtils._();

	// static aliases (checkout base methods for documentation)
	static AppLocale parse(String rawLocale) => instance.parse(rawLocale);
	static AppLocale parseLocaleParts({required String languageCode, String? scriptCode, String? countryCode}) => instance.parseLocaleParts(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);
	static AppLocale findDeviceLocale() => instance.findDeviceLocale();
	static List<Locale> get supportedLocales => instance.supportedLocales;
	static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
}

// translations

// Path: <root>
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	// Translations
	late final _StringsAppEn app = _StringsAppEn._(_root);
	late final _StringsHomeEn home = _StringsHomeEn._(_root);
	late final _StringsChatEn chat = _StringsChatEn._(_root);
	late final _StringsAuthEn auth = _StringsAuthEn._(_root);
}

// Path: app
class _StringsAppEn {
	_StringsAppEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get name => 'AI.MY';
	String get error => 'An error occurs';
	String get more => 'more';
	String get edit => 'edit';
	String get delete => 'delete';
	String get cancel => 'cancel';
	String get confirm => 'confirm';
	String get clear => 'Clean';
	String get text_field_hint => 'Ask me anything...automatic line feed';
	String get text_field_hint_record => 'I\'m listening in...';
	String get big_text => 'Thanks to the high-quality feedback from Flutter users, in this release we have continued to improve the performance of Impeller on iOS. As a result of many different optimizations, the Impeller renderer on iOS now not only has lower latency (by completely eliminating shader compilation jank), but on some benchmarks also have higher average throughput. In particular, on our flutter/gallery transitions performance benchmark, average frame rasterization time is now around half of what it was with Skia';
	String get copy => 'Copy';
	String get copy_success => 'Copy success';
	String get uploading => 'File is uploading...';
}

// Path: home
class _StringsHomeEn {
	_StringsHomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get drawer_subtitle => 'CHANGE · ACTION · CONSENSUS';
	String get appbar_action => 'Embracing Tech · Creating Future';
	String get content_action => 'Processing...';
}

// Path: chat
class _StringsChatEn {
	_StringsChatEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get menuName => 'AI-Conversation';
	String get default_tip => 'Hi, I\'m AI Assistant, just ask me if you have any questions...';
	String get create_chat => 'Create Chat';
	String get create_chat_title => 'New Chat';
	String get prompt => 'Prompt';
	String get edit_prompt => 'Edit Prompt';
	String get edit_prompt_hint => 'Please enter the prompt name';
	String get chat_prompt_topic1 => 'Chinese Translate';
	String get chat_prompt_topic2 => 'Job Description';
	String get chat_prompt_topic3 => 'ChatGPT Training';
	String get chat_prompt_topic4 => 'Text Summary';
	String get chat_prompt_topic5 => 'Meeting Summary';
	String get chat_prompt_topic6 => 'Text Extraction';
	String get chat_prompt_topic7 => 'Project Plan';
	String get chat_prompt_topic8 => 'Product Document';
	String get chat_prompt_content1 => 'Help you translate English to Chinese';
	String get chat_prompt_content2 => 'Help you to write a job description';
	String get chat_prompt_content3 => 'Help you to write a ChatGPT training plan';
	String get chat_prompt_content4 => 'Helps you write paragraph text summaries';
	String get chat_prompt_content5 => 'Help you write meeting summaries';
	String get chat_prompt_content6 => 'Extract keywords info for you';
	String get chat_prompt_content7 => 'Help you write a project plan';
	String get chat_prompt_content8 => 'Help you write a product PRD';
	String get chat_prompt_label => 'Generative Text';
}

// Path: auth
class _StringsAuthEn {
	_StringsAuthEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get authName => 'Sign-In';
	String get auth_title => 'Join In    @AI.MY';
	String get auth_email_title => 'E-mail';
	String get auth_email_hint => 'Input email address like QQ/163/gmail';
	String get auth_password_title => 'Password';
	String get auth_password_title_label => '（At least 8 bits in length）';
	String get auth_password_hint => 'Set your password';
	String get auth_submit => 'Sign In';
	String get auth_submit_tips => '  New users will be automatically registered';
	String get auth_email_empty => 'Please input your E-mail address';
	String get auth_email_format_error => 'Incorrect input of E-mail format';
	String get auth_password_empty => 'Please set your password';
	String get auth_password_length_error => 'At least 8 bits in length';
	String get auth_password_format_error => 'Password must contain letters and numbers';
	String get auth_sign_loading => 'Signing in now...';
	String get auth_sign_success => 'Sign in success';
}

// Path: <root>
class _StringsZhCn implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsZhCn.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.zhCn,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <zh-CN>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	@override late final _StringsZhCn _root = this; // ignore: unused_field

	// Translations
	@override late final _StringsAppZhCn app = _StringsAppZhCn._(_root);
	@override late final _StringsHomeZhCn home = _StringsHomeZhCn._(_root);
	@override late final _StringsChatZhCn chat = _StringsChatZhCn._(_root);
	@override late final _StringsAuthZhCn auth = _StringsAuthZhCn._(_root);
}

// Path: app
class _StringsAppZhCn implements _StringsAppEn {
	_StringsAppZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get name => 'AI.MY';
	@override String get error => '发生错误';
	@override String get more => '更多';
	@override String get edit => '编辑';
	@override String get delete => '删除';
	@override String get cancel => '取消';
	@override String get confirm => '确认';
	@override String get clear => '清除记录';
	@override String get text_field_hint => '有问题尽管问我...自动换行';
	@override String get text_field_hint_record => '我正在聆听中...';
	@override String get big_text => '得益于 Flutter 用户的高质量反馈，我们在此版本中继续改进了 Impeller 在 iOS 上的性能。由于进行了多种优化，现在 iOS 上的 Impeller 渲染器不仅延迟更低（通过完全消除着色器编译抖动），而且在某些基准测试中平均吞吐量也更高。特别是在我们的 flutter/gallery 过渡性能基准测试中，平均帧光栅化时间现在大约是 Skia 时的一半。';
	@override String get copy => '复制文本';
	@override String get copy_success => '文本复制成功';
	@override String get uploading => '文件正在上传中...';
}

// Path: home
class _StringsHomeZhCn implements _StringsHomeEn {
	_StringsHomeZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get drawer_subtitle => '变 化 · 行 动 · 共 识';
	@override String get appbar_action => ' 拥 抱 科 技 · 创 造 未 来 ';
	@override String get content_action => '正在处理中';
}

// Path: chat
class _StringsChatZhCn implements _StringsChatEn {
	_StringsChatZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get menuName => '智能对话';
	@override String get default_tip => '你好，我是AI助手，有问题尽管问我...';
	@override String get create_chat => '创建聊天';
	@override String get create_chat_title => '新聊天';
	@override String get prompt => '主题';
	@override String get edit_prompt => '编辑主题';
	@override String get edit_prompt_hint => '请输入主题名称';
	@override String get chat_prompt_topic1 => '中文翻译';
	@override String get chat_prompt_topic2 => '招聘岗位JD';
	@override String get chat_prompt_topic3 => 'ChatGPT培训计划';
	@override String get chat_prompt_topic4 => '段落文本总结';
	@override String get chat_prompt_topic5 => '会议总结';
	@override String get chat_prompt_topic6 => '文字信息提取';
	@override String get chat_prompt_topic7 => '项目计划书';
	@override String get chat_prompt_topic8 => '产品需求文档';
	@override String get chat_prompt_content1 => '帮你翻译英文技术文档';
	@override String get chat_prompt_content2 => '帮你书写招聘岗位对应JD';
	@override String get chat_prompt_content3 => '帮你写ChatGPT培训计划';
	@override String get chat_prompt_content4 => '帮你书写段落文本总结';
	@override String get chat_prompt_content5 => '帮你书写会议总结';
	@override String get chat_prompt_content6 => '帮你提取关键字信息';
	@override String get chat_prompt_content7 => '帮你写项目计划书';
	@override String get chat_prompt_content8 => '帮你写产品需求文档';
	@override String get chat_prompt_label => '文本生成';
}

// Path: auth
class _StringsAuthZhCn implements _StringsAuthEn {
	_StringsAuthZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get authName => '登录';
	@override String get auth_title => '加 入    @AI.MY';
	@override String get auth_email_title => '邮箱地址';
	@override String get auth_email_hint => '输入你的QQ/163/gmail邮箱';
	@override String get auth_password_title => '设置密码';
	@override String get auth_password_title_label => '（长度至少8位以上）';
	@override String get auth_password_hint => '输入你的登录密码';
	@override String get auth_submit => '登 录';
	@override String get auth_submit_tips => '  新用户未注册时将自动注册';
	@override String get auth_email_empty => '请输入你的邮箱地址';
	@override String get auth_email_format_error => '邮箱地址格式错误';
	@override String get auth_password_empty => '请设置密码';
	@override String get auth_password_length_error => '密码长度至少8位以上';
	@override String get auth_password_format_error => '密码必须包含字母和数字';
	@override String get auth_sign_loading => '正在登录中...';
	@override String get auth_sign_success => '登录成功';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'app.name': return 'AI.MY';
			case 'app.error': return 'An error occurs';
			case 'app.more': return 'more';
			case 'app.edit': return 'edit';
			case 'app.delete': return 'delete';
			case 'app.cancel': return 'cancel';
			case 'app.confirm': return 'confirm';
			case 'app.clear': return 'Clean';
			case 'app.text_field_hint': return 'Ask me anything...automatic line feed';
			case 'app.text_field_hint_record': return 'I\'m listening in...';
			case 'app.big_text': return 'Thanks to the high-quality feedback from Flutter users, in this release we have continued to improve the performance of Impeller on iOS. As a result of many different optimizations, the Impeller renderer on iOS now not only has lower latency (by completely eliminating shader compilation jank), but on some benchmarks also have higher average throughput. In particular, on our flutter/gallery transitions performance benchmark, average frame rasterization time is now around half of what it was with Skia';
			case 'app.copy': return 'Copy';
			case 'app.copy_success': return 'Copy success';
			case 'app.uploading': return 'File is uploading...';
			case 'home.drawer_subtitle': return 'CHANGE · ACTION · CONSENSUS';
			case 'home.appbar_action': return 'Embracing Tech · Creating Future';
			case 'home.content_action': return 'Processing...';
			case 'chat.menuName': return 'AI-Conversation';
			case 'chat.default_tip': return 'Hi, I\'m AI Assistant, just ask me if you have any questions...';
			case 'chat.create_chat': return 'Create Chat';
			case 'chat.create_chat_title': return 'New Chat';
			case 'chat.prompt': return 'Prompt';
			case 'chat.edit_prompt': return 'Edit Prompt';
			case 'chat.edit_prompt_hint': return 'Please enter the prompt name';
			case 'chat.chat_prompt_topic1': return 'Chinese Translate';
			case 'chat.chat_prompt_topic2': return 'Job Description';
			case 'chat.chat_prompt_topic3': return 'ChatGPT Training';
			case 'chat.chat_prompt_topic4': return 'Text Summary';
			case 'chat.chat_prompt_topic5': return 'Meeting Summary';
			case 'chat.chat_prompt_topic6': return 'Text Extraction';
			case 'chat.chat_prompt_topic7': return 'Project Plan';
			case 'chat.chat_prompt_topic8': return 'Product Document';
			case 'chat.chat_prompt_content1': return 'Help you translate English to Chinese';
			case 'chat.chat_prompt_content2': return 'Help you to write a job description';
			case 'chat.chat_prompt_content3': return 'Help you to write a ChatGPT training plan';
			case 'chat.chat_prompt_content4': return 'Helps you write paragraph text summaries';
			case 'chat.chat_prompt_content5': return 'Help you write meeting summaries';
			case 'chat.chat_prompt_content6': return 'Extract keywords info for you';
			case 'chat.chat_prompt_content7': return 'Help you write a project plan';
			case 'chat.chat_prompt_content8': return 'Help you write a product PRD';
			case 'chat.chat_prompt_label': return 'Generative Text';
			case 'auth.authName': return 'Sign-In';
			case 'auth.auth_title': return 'Join In    @AI.MY';
			case 'auth.auth_email_title': return 'E-mail';
			case 'auth.auth_email_hint': return 'Input email address like QQ/163/gmail';
			case 'auth.auth_password_title': return 'Password';
			case 'auth.auth_password_title_label': return '（At least 8 bits in length）';
			case 'auth.auth_password_hint': return 'Set your password';
			case 'auth.auth_submit': return 'Sign In';
			case 'auth.auth_submit_tips': return '  New users will be automatically registered';
			case 'auth.auth_email_empty': return 'Please input your E-mail address';
			case 'auth.auth_email_format_error': return 'Incorrect input of E-mail format';
			case 'auth.auth_password_empty': return 'Please set your password';
			case 'auth.auth_password_length_error': return 'At least 8 bits in length';
			case 'auth.auth_password_format_error': return 'Password must contain letters and numbers';
			case 'auth.auth_sign_loading': return 'Signing in now...';
			case 'auth.auth_sign_success': return 'Sign in success';
			default: return null;
		}
	}
}

extension on _StringsZhCn {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'app.name': return 'AI.MY';
			case 'app.error': return '发生错误';
			case 'app.more': return '更多';
			case 'app.edit': return '编辑';
			case 'app.delete': return '删除';
			case 'app.cancel': return '取消';
			case 'app.confirm': return '确认';
			case 'app.clear': return '清除记录';
			case 'app.text_field_hint': return '有问题尽管问我...自动换行';
			case 'app.text_field_hint_record': return '我正在聆听中...';
			case 'app.big_text': return '得益于 Flutter 用户的高质量反馈，我们在此版本中继续改进了 Impeller 在 iOS 上的性能。由于进行了多种优化，现在 iOS 上的 Impeller 渲染器不仅延迟更低（通过完全消除着色器编译抖动），而且在某些基准测试中平均吞吐量也更高。特别是在我们的 flutter/gallery 过渡性能基准测试中，平均帧光栅化时间现在大约是 Skia 时的一半。';
			case 'app.copy': return '复制文本';
			case 'app.copy_success': return '文本复制成功';
			case 'app.uploading': return '文件正在上传中...';
			case 'home.drawer_subtitle': return '变 化 · 行 动 · 共 识';
			case 'home.appbar_action': return ' 拥 抱 科 技 · 创 造 未 来 ';
			case 'home.content_action': return '正在处理中';
			case 'chat.menuName': return '智能对话';
			case 'chat.default_tip': return '你好，我是AI助手，有问题尽管问我...';
			case 'chat.create_chat': return '创建聊天';
			case 'chat.create_chat_title': return '新聊天';
			case 'chat.prompt': return '主题';
			case 'chat.edit_prompt': return '编辑主题';
			case 'chat.edit_prompt_hint': return '请输入主题名称';
			case 'chat.chat_prompt_topic1': return '中文翻译';
			case 'chat.chat_prompt_topic2': return '招聘岗位JD';
			case 'chat.chat_prompt_topic3': return 'ChatGPT培训计划';
			case 'chat.chat_prompt_topic4': return '段落文本总结';
			case 'chat.chat_prompt_topic5': return '会议总结';
			case 'chat.chat_prompt_topic6': return '文字信息提取';
			case 'chat.chat_prompt_topic7': return '项目计划书';
			case 'chat.chat_prompt_topic8': return '产品需求文档';
			case 'chat.chat_prompt_content1': return '帮你翻译英文技术文档';
			case 'chat.chat_prompt_content2': return '帮你书写招聘岗位对应JD';
			case 'chat.chat_prompt_content3': return '帮你写ChatGPT培训计划';
			case 'chat.chat_prompt_content4': return '帮你书写段落文本总结';
			case 'chat.chat_prompt_content5': return '帮你书写会议总结';
			case 'chat.chat_prompt_content6': return '帮你提取关键字信息';
			case 'chat.chat_prompt_content7': return '帮你写项目计划书';
			case 'chat.chat_prompt_content8': return '帮你写产品需求文档';
			case 'chat.chat_prompt_label': return '文本生成';
			case 'auth.authName': return '登录';
			case 'auth.auth_title': return '加 入    @AI.MY';
			case 'auth.auth_email_title': return '邮箱地址';
			case 'auth.auth_email_hint': return '输入你的QQ/163/gmail邮箱';
			case 'auth.auth_password_title': return '设置密码';
			case 'auth.auth_password_title_label': return '（长度至少8位以上）';
			case 'auth.auth_password_hint': return '输入你的登录密码';
			case 'auth.auth_submit': return '登 录';
			case 'auth.auth_submit_tips': return '  新用户未注册时将自动注册';
			case 'auth.auth_email_empty': return '请输入你的邮箱地址';
			case 'auth.auth_email_format_error': return '邮箱地址格式错误';
			case 'auth.auth_password_empty': return '请设置密码';
			case 'auth.auth_password_length_error': return '密码长度至少8位以上';
			case 'auth.auth_password_format_error': return '密码必须包含字母和数字';
			case 'auth.auth_sign_loading': return '正在登录中...';
			case 'auth.auth_sign_success': return '登录成功';
			default: return null;
		}
	}
}
