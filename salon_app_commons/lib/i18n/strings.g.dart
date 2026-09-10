/// Generated file. Do not edit.
///
/// Original: lib/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 2
/// Strings: 530 (265 per locale)
///
/// Built on 2025-07-03 at 10:00 UTC

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
	ja(languageCode: 'ja', build: _StringsJa.build);

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

// interfaces generated as mixins

mixin QAModel {
	String get q;
	String get a;

	@override
	bool operator ==(Object other) => other is QAModel && q == other.q && a == other.a;

	@override
	int get hashCode => q.hashCode * a.hashCode;
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
	late final _StringsWhyEn why = _StringsWhyEn._(_root);
	late final _StringsWorksEn works = _StringsWorksEn._(_root);
	late final _StringsAboutEn about = _StringsAboutEn._(_root);
	late final _StringsPlanEn plan = _StringsPlanEn._(_root);
	late final _StringsPriceEn price = _StringsPriceEn._(_root);
	late final _StringsIntervalEn interval = _StringsIntervalEn._(_root);
	String get cta_github => 'Sign up with GitHub';
	String get cta => 'Sign up with Email';
	String get cta_available_count1 => 'Only ';
	String get cta_available_count2 => ' more available now.';
	String get cta_no_available => 'No more available right now.';
	late final _StringsPeopleEn people = _StringsPeopleEn._(_root);
	late final _StringsVoiceEn voice = _StringsVoiceEn._(_root);
	late final _StringsProjectsEn projects = _StringsProjectsEn._(_root);
	late final _StringsMediaEn media = _StringsMediaEn._(_root);
	late final _StringsJoinEn join = _StringsJoinEn._(_root);
	late final _StringsQaEn qa = _StringsQaEn._(_root);
	late final _StringsMessageEn message = _StringsMessageEn._(_root);
	late final _StringsNewMembersEn newMembers = _StringsNewMembersEn._(_root);
	late final _StringsMenuEn menu = _StringsMenuEn._(_root);
	late final _StringsFooterEn footer = _StringsFooterEn._(_root);
	String get underMaintenance => 'Currently under maintenance';
	late final _StringsScheduleEn schedule = _StringsScheduleEn._(_root);
}

// Path: why
class _StringsWhyEn {
	_StringsWhyEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get why_flutter => 'Why Flutter?';
	String get description => 'Flutter is rapidly gaining popularity with incredible momentum. The enthusiasm of its developer community, backed by Google, along with its high productivity and excellent developer UX, have led to its quick adoption in the business world. Flutter Daigaku resonated with the appeal of Flutter and has been supporting the Japanese Flutter community since April 2020. Moving forward, we aim to include the global community, creating a world where developers can enjoy learning, exchanging work, and sharing app development knowledge.';
	String get learn_more => 'Learn more about Flutter';
}

// Path: works
class _StringsWorksEn {
	_StringsWorksEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get member_development_record => 'Members\' Developments';
	String get released_ago => 'Released';
	String get updated_ago => 'Updated';
	String get joint_development => 'Joint Development';
	String get individual_development => 'Individual Development';
}

// Path: about
class _StringsAboutEn {
	_StringsAboutEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get three_features => '3 features of Flutter Daigaku';
	String get youtube_free => 'Flutter lecture YouTube is available for free';
	String get live_support => 'Live instructor support';
	String get ai_training => 'Ask both AI and human instructors at the same time';
	String get coach => 'We will be your learning coach.';
	String get learn_from_code => 'Learn from reading the code';
	String get flutter_textbook => 'Learn from the Flutter textbook';
	String get joint_study_meeting => 'Joint study meetings for output';
	String get individual_development_presentation => 'Boost motivation with individual development presentations';
	String get team_development => 'Develop as a team';
	String get engineer_introduction => 'We also introduce engineers';
	String get slack_interaction => 'Way too active Slack communications';
	String get online_workroom => 'Concentrate in an online workspace';
	String get online_exchange_meeting => 'Make friends at online exchange meetups';
	String get share_house_off_meeting => 'Share houses and in-person meetups';
	String get job_is_here => 'Your job is here';
	String get youtube_free_description => 'YouTube channel \'Flutter Daigaku\' offers free learning materials. Please check it out.';
	String get live_support_description => 'For those in the Flutter training plan, active Flutter engineers provide live support. You can also post questions on GitHub issues if you need text-based help.';
	String get ai_training_description => 'With the AI Training Plan, you can ask unlimited questions to Gemini 2.5 Pro, the latest AI model. Get instant answers 24/7 and accelerate your Flutter learning with human instructor support when needed.';
	String get learn_from_code_description => 'You can view the raw code of the Flutter Daigaku app and apps developed collaboratively on Github. Please check out our free public repositories.';
	String get flutter_textbook_description => 'If you\'re on the Task Learning Plan or higher, you can learn with the Flutter Daigaku\'s exclusive textbook (generally priced at 5,000 yen on Zenn) and receive reviews when you complete tasks.';
	String get joint_study_meeting_description => 'We hold collaborative study meetings on Wednesdays at 9 PM.';
	String get individual_development_presentation_description => 'Monthly presentations are held to showcase individual development achievements.';
	String get team_development_description => 'Teams are formed every three months for collaborative development!';
	String get engineer_introduction_description1 => 'At Flutter Daigaku, we accept inquiries from those looking for Flutter engineers. We can introduce you to suitable engineers from the ';
	String get engineer_introduction_description2 => ' engineers participating in Flutter Daigaku.';
	String get slack_interaction_description => 'Conversations are not only about exchanging information on Flutter, but also about various topics from the latest AI trends and unique career discussions for engineers to talks about expanding overseas. Just one day without checking Slack results in a huge backlog of unread messages.';
	String get online_workroom_description => 'We have prepared an online workspace using Gather.';
	String get online_exchange_meeting_description => 'We hold online exchange meetups once a month using Zoom.';
	String get share_house_off_meeting_description => 'We have a share house called \'FlaHa\'(short sound of Flutter-House) in Ebisu, Tokyo, and an old house called \'Flutter Besso\' in Higashiomi, Shiga, where Flutter Daigaku members live. In addition, in-person meetups are held every two months in Tokyo, Sapporo, Nagoya, Osaka, Fukuoka, etc.';
	String get job_is_here_description => 'Flutter Daigaku is a community where you can learn Flutter and find a job. We share Flutter jobs, and we also introduce engineers to companies looking for Flutter engineers.';
	String get youtube_free_button => 'YouTube \'Flutter Daigaku\'';
	String get ai_training_button => 'What is AI Training Plan?';
	String get learn_from_code_button => 'GitHub \'Flutter Daigaku\'';
	String get flutter_textbook_button => 'Zenn Book \'Flutter Textbook\'';
	String get joint_study_meeting_button => 'Summary of Joint Study Meetings';
	String get individual_development_presentation_button => 'What is Individual Development Presentation?';
	String get team_development_button => 'What is Team Development?';
	String get engineer_introduction_button => 'Looking for Flutter Engineers?';
	String get slack_interaction_button => 'How to Use Flutter Daigaku on Slack';
	String get online_workroom_button => 'What is Online Workspace?';
	String get online_exchange_meeting_button => 'What is Online Exchange Meetup?';
	String get share_house_off_meeting_button => 'Flutter Besso\'s Twitter';
	String get mentor_plans => 'Exclusive mentoring platform within Flutter Daigaku';
	String get mentor_plans_description => 'There exists a platform where you can receive one-on-one instruction from a teacher within Flutter Daigaku, started under the alias \'CodeBoy2\'. Teachers are Flutter Daigaku members and can provide instruction and mentoring through a learning platform that only takes an extraordinary fee of 4-10%. Learners can receive one-on-one instruction from excellent engineers within Flutter Daigaku.';
}

// Path: plan
class _StringsPlanEn {
	_StringsPlanEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get community => 'Community Plan';
	String get learning => 'Learning Plan';
	String get trainingLight => 'Light Training Plan';
	String get training => 'Training Plan';
	String get aiTraining => 'AI Training Plan';
}

// Path: price
class _StringsPriceEn {
	_StringsPriceEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final _StringsPriceLPDescriptionEn lPDescription = _StringsPriceLPDescriptionEn._(_root);
	String get lPFeature1 => '・Access to the app\n・Join the Slack\n・Browse the GitHub\n・Collaborate on dev projects\n・Group study\n・Access videos\n・Networking events';
	String get lPFeature2 => 'Everything in Community, and\n・Access to exclusive materials';
	String get lPFeature3 => 'Everything in Learning, and\n・Light support included';
	String get lPFeature4 => 'Everything in Learning, and\n・Full support included\n・Text questions on github\n・Give away 2,860JPY Flutter Book';
	String get lPFeature5 => 'Everything in Learning, and\n・Unlimited Gemini 2.5 Pro chat \n・10y experienced Human instructor support when needed\n・Give away 2,860JPY Flutter Book';
	String get yen => 'JPY';
	String get yen_per_month => ' JPY / mo';
	String get month => 'mo';
	String get threeMonth => '3mo';
	String get sixMonth => '6mo';
	String get year => 'yr';
	String get if_convert_to_month => 'Equivalent to';
	String get threeMonthsOff => '3 months off!!';
}

// Path: interval
class _StringsIntervalEn {
	_StringsIntervalEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get monthly => 'Monthly';
	String get threeMonth => '3Month';
	String get sixMonth => '6Month';
	String get annual => 'Annual';
}

// Path: people
class _StringsPeopleEn {
	_StringsPeopleEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get subtitle1 => 'Instructors';
	String get subtitle2 => 'Powerful members';
	String get other1 => 'The total is';
	String get other2 => 'members!';
	String get slackAPI => '※Counted every hour using Slack API.';
	late final _StringsPeoplePeoplesEn peoples = _StringsPeoplePeoplesEn._(_root);
}

// Path: voice
class _StringsVoiceEn {
	_StringsVoiceEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'Here are some blogs\nabout Flutter Daigaku in Japanese';
}

// Path: projects
class _StringsProjectsEn {
	_StringsProjectsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get subtitle => 'Cool things members are doing';
	late final _StringsProjectsFlutterHouseEn flutter_house = _StringsProjectsFlutterHouseEn._(_root);
	late final _StringsProjectsFlutterGakkaiEn flutter_gakkai = _StringsProjectsFlutterGakkaiEn._(_root);
	late final _StringsProjectsWeeklyFlutterUniversityEn weekly_flutter_university = _StringsProjectsWeeklyFlutterUniversityEn._(_root);
	late final _StringsProjectsHackathonVictoryEn hackathon_victory = _StringsProjectsHackathonVictoryEn._(_root);
	late final _StringsProjectsFlutterVillaEn flutter_villa = _StringsProjectsFlutterVillaEn._(_root);
	late final _StringsProjectsFlutterWomenEn flutter_women = _StringsProjectsFlutterWomenEn._(_root);
	late final _StringsProjectsXxDartEn xx_dart = _StringsProjectsXxDartEn._(_root);
	late final _StringsProjectsMorningMokumokuEn morning_mokumoku = _StringsProjectsMorningMokumokuEn._(_root);
	late final _StringsProjectsTokyoFlutterHackathonEn tokyo_flutter_hackathon = _StringsProjectsTokyoFlutterHackathonEn._(_root);
	late final _StringsProjectsTerakoyaEn terakoya = _StringsProjectsTerakoyaEn._(_root);
	late final _StringsProjectsFlutterBookEn flutter_book = _StringsProjectsFlutterBookEn._(_root);
	late final _StringsProjectsGlobalGamersChallengeEn global_gamers_challenge = _StringsProjectsGlobalGamersChallengeEn._(_root);
	late final _StringsProjectsFlutterNinjasEn flutter_ninjas = _StringsProjectsFlutterNinjasEn._(_root);
}

// Path: media
class _StringsMediaEn {
	_StringsMediaEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get subtitle => 'Featured in Japanese media.';
}

// Path: join
class _StringsJoinEn {
	_StringsJoinEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get subtitle => 'Joining process';
	late final _StringsJoinJoinStepsEn joinSteps = _StringsJoinJoinStepsEn._(_root);
}

// Path: qa
class _StringsQaEn {
	_StringsQaEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get subtitle => 'Frequently Asked Questions';
	List<QAModel> get qaList => [
		_StringsQa$qaList$0i0$En._(_root),
		_StringsQa$qaList$0i1$En._(_root),
		_StringsQa$qaList$0i2$En._(_root),
		_StringsQa$qaList$0i3$En._(_root),
		_StringsQa$qaList$0i4$En._(_root),
		_StringsQa$qaList$0i5$En._(_root),
		_StringsQa$qaList$0i6$En._(_root),
		_StringsQa$qaList$0i7$En._(_root),
		_StringsQa$qaList$0i8$En._(_root),
	];
}

// Path: message
class _StringsMessageEn {
	_StringsMessageEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'What Makes Flutter Daigaku Community Special?';
	String get message => 'While technology continues to evolve rapidly, at Flutter Daigaku we value something beyond just technical skill acquisition - the power of a supportive learning community.\n\nWhat we treasure most is our "collaborative learning environment" where every member supports each other\'s growth and development.\n\nRather than struggling with questions and challenges alone, our experienced members generously share their knowledge, creating a welcoming space where even beginners can learn with confidence.\n\nThrough joint development projects and online study sessions, members gain practical skills that individual learning cannot provide, and most importantly, they build valuable connections with fellow developers.\n\nWould you like to join us in building a learning community that values both technical excellence and meaningful human connections?\n\nRepresentative of Flutter Daigaku,\nKei Fujikawa';
}

// Path: newMembers
class _StringsNewMembersEn {
	_StringsNewMembersEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get dayAgo => ' days ago';
	String get hourAgo => ' hours ago';
	String get minuteAgo => ' minutes ago';
	String get secondAgo => ' seconds ago';
	String get future => 'future';
	String get ni => ', ';
	String get joined => ' joined!';
}

// Path: menu
class _StringsMenuEn {
	_StringsMenuEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get developmentExperience => 'Works';
	String get threeFeatures => 'Features';
	String get pricePlan => 'Price';
	String get members => 'Members';
	String get memberVoice => 'Voice';
	String get enrollmentProcess => 'Joining Process';
	String get faq => 'FAQ';
	String get login => 'Log In';
}

// Path: footer
class _StringsFooterEn {
	_StringsFooterEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get terms => 'Terms and Conditions';
	String get tokusho => 'Specified Commercial Transactions Act';
	String get privacyPolicy => 'Privacy Policy';
	String get operatingCompany => 'Company';
}

// Path: schedule
class _StringsScheduleEn {
	_StringsScheduleEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Schedule Booking';
	String get description => 'You can ask both AI and human instructors at the same time\nfor individual consultations and mentoring.\nPlease book your schedule from Calendly page.';
	String get calendlyButton => 'Book with Calendly';
}

// Path: price.lPDescription
class _StringsPriceLPDescriptionEn {
	_StringsPriceLPDescriptionEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get community => 'Study together in a community';
	String get learning => 'Learn Flutter with exclusive materials';
	String get trainingLight => 'Learn Flutter with professional help sometimes';
	String get training => 'Master Flutter with professional help';
	String get aiTraining => 'Learn Flutter with unlimited AI';
}

// Path: people.peoples
class _StringsPeoplePeoplesEn {
	_StringsPeoplePeoplesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final _StringsPeoplePeoplesKosukeEn kosuke = _StringsPeoplePeoplesKosukeEn._(_root);
	late final _StringsPeoplePeoplesDaigoEn daigo = _StringsPeoplePeoplesDaigoEn._(_root);
	late final _StringsPeoplePeoplesKboyEn kboy = _StringsPeoplePeoplesKboyEn._(_root);
	late final _StringsPeoplePeoplesMasakiEn masaki = _StringsPeoplePeoplesMasakiEn._(_root);
	late final _StringsPeoplePeoplesUetomoEn uetomo = _StringsPeoplePeoplesUetomoEn._(_root);
	late final _StringsPeoplePeoplesTokkuuEn tokkuu = _StringsPeoplePeoplesTokkuuEn._(_root);
	late final _StringsPeoplePeoplesCoboEn cobo = _StringsPeoplePeoplesCoboEn._(_root);
	late final _StringsPeoplePeoplesGanEn gan = _StringsPeoplePeoplesGanEn._(_root);
	late final _StringsPeoplePeoplesOtaEn ota = _StringsPeoplePeoplesOtaEn._(_root);
	late final _StringsPeoplePeoplesHeyheyEn heyhey = _StringsPeoplePeoplesHeyheyEn._(_root);
	late final _StringsPeoplePeoplesMinnEn minn = _StringsPeoplePeoplesMinnEn._(_root);
	late final _StringsPeoplePeoplesOdakenEn odaken = _StringsPeoplePeoplesOdakenEn._(_root);
	late final _StringsPeoplePeoplesMiyajicEn miyajic = _StringsPeoplePeoplesMiyajicEn._(_root);
	late final _StringsPeoplePeoplesAoiEn aoi = _StringsPeoplePeoplesAoiEn._(_root);
	late final _StringsPeoplePeoplesNaokiEn naoki = _StringsPeoplePeoplesNaokiEn._(_root);
	late final _StringsPeoplePeoplesKentyEn kenty = _StringsPeoplePeoplesKentyEn._(_root);
	late final _StringsPeoplePeoplesFenEn fen = _StringsPeoplePeoplesFenEn._(_root);
}

// Path: projects.flutter_house
class _StringsProjectsFlutterHouseEn {
	_StringsProjectsFlutterHouseEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Flutter House';
	String get description => 'Flutter House is a sharehouse for Flutter engineers founded by Konbu-san. Located in Ebisu, Tokyo, it\'s a 4-6 person apartment where engineers live and enjoy work and play to the fullest. A drinking party called UTAGE is held once a month. It\'s a base in Tokyo where Flutter Daigaku members can easily drop in.';
	String get dateDescription => 'October 2020~';
}

// Path: projects.flutter_gakkai
class _StringsProjectsFlutterGakkaiEn {
	_StringsProjectsFlutterGakkaiEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Flutter Gakkai';
	String get description => 'Flutter Gakkai is a study group for Flutter engineers. It\'s an online study group that aims to boost the Flutter community in Japan beyond Flutter Daigaku. It has been held online twice so far, with the aim of holding a large-scale offline event in the future.';
	String get dateDescription => 'January 2022~';
}

// Path: projects.weekly_flutter_university
class _StringsProjectsWeeklyFlutterUniversityEn {
	_StringsProjectsWeeklyFlutterUniversityEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Weekly Flutter Daigaku';
	String get description => 'Weekly Flutter Daigaku is a WEB media started by Aoi-san as editor-in-chief. The \'This Week\'s Flutter News\' updated every week allows you to catch up with the latest Flutter information. In addition, at the time of the latest release of Flutter official, it releases a Japanese summary article at the fastest speed and leads the Japanese Flutter media.';
	String get dateDescription => 'March 2022~';
}

// Path: projects.hackathon_victory
class _StringsProjectsHackathonVictoryEn {
	_StringsProjectsHackathonVictoryEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Hackathon victory';
	String get description => 'Flutter lovers participated in the hackathon as a team within Flutter Daigaku. In the first round of Spajam2022, FlutterLovers won the grand prize. The Flutter x Firebase skill set is fast and suitable for hackathons. There are plans for other team participation in the future, so expectations are high.';
	String get dateDescription => 'August 2022';
}

// Path: projects.flutter_villa
class _StringsProjectsFlutterVillaEn {
	_StringsProjectsFlutterVillaEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Flutter Besso';
	String get description => 'Flutter Besso started when Konbu-san purchased an old Japanese house in Higashiomi City, Shiga Prefecture. It is the second sharehouse after Flutter House and is also expected to be a base for Flutter camps in the future. There is a handmade sauna house in the garden, a gym with a power rack in the garage, and high-speed wifi is also available. You can stay overnight by contacting us in advance.';
	String get dateDescription => 'August 2022~';
}

// Path: projects.flutter_women
class _StringsProjectsFlutterWomenEn {
	_StringsProjectsFlutterWomenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Flutter Womens';
	String get description => 'Female members of Flutter Daigaku regularly gather for girls\' meetings and app development. Currently, the Flutter Women team is jointly developing an app for Christmas!';
	String get dateDescription => 'October 2022~';
}

// Path: projects.xx_dart
class _StringsProjectsXxDartEn {
	_StringsProjectsXxDartEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => '〇〇.dart';
	String get description => 'Under the concept of "locality × Flutter," we hold a Flutter study group called "〇〇.dart." Anyone interested in Flutter is welcome to participate, not just those enrolled in Flutter Daigaku. In May, there are plans to hold Osaka.dart, and Tokyo.dart in June.. Additionally, we plan to hold Hokkaido.dart during the beer garden season in August.';
	String get dateDescription => 'March 2023~';
}

// Path: projects.morning_mokumoku
class _StringsProjectsMorningMokumokuEn {
	_StringsProjectsMorningMokumokuEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Morning Mokumoku';
	String get description => 'The gathering place is a virtual workspace called Gather. Every morning from 7:10 to 8:00, we work together on Gather tables and then gather at the lower left table at 8:00 to report on what we accomplished that day. This habit helps us develop a routine of waking up early and working together.';
	String get dateDescription => 'April 2023~';
}

// Path: projects.tokyo_flutter_hackathon
class _StringsProjectsTokyoFlutterHackathonEn {
	_StringsProjectsTokyoFlutterHackathonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Tokyo Flutter Hackathon';
	String get description => 'Flutter Daigaku and Yumemi jointly held the Tokyo Flutter Hackathon for two days on September 30th and October 1st. We had many companies sponsor the event, and rent the CyberAgent venue to hold the event. There were over 100 participants and 23 participating teams.';
	String get dateDescription => 'September 2023';
}

// Path: projects.terakoya
class _StringsProjectsTerakoyaEn {
	_StringsProjectsTerakoyaEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Terakoya Tech';
	String get description => 'Terakoya Tech is an engineering training program where you can learn highly demanded tools and languages as future engineering skills within six months. It\'s a selective program, completely free, and was conducted in collaboration with Ritsuan STC, Cloudtech, and Flutter University.';
	String get dateDescription => 'December 2023 to May 2024';
}

// Path: projects.flutter_book
class _StringsProjectsFlutterBookEn {
	_StringsProjectsFlutterBookEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Flutter Tutorial Book on sale';
	String get description => 'Flutter Daigaku founder kboy has published an introductory book on Flutter from Gijutsu Hyoronsha.';
	String get dateDescription => 'December 2023';
}

// Path: projects.global_gamers_challenge
class _StringsProjectsGlobalGamersChallengeEn {
	_StringsProjectsGlobalGamersChallengeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Best Integration in Japanese - 1st place at Global Gamers Challenge';
	String get description => 'Flutter Daigaku members participated in the Global Gamers Challenge, a hackathon for game development. The team\'s app called Turtle escape won the Google Wallet - Best Integration in Japanese - 1st place. They got 7500USD.';
	String get dateDescription => 'May 2024';
}

// Path: projects.flutter_ninjas
class _StringsProjectsFlutterNinjasEn {
	_StringsProjectsFlutterNinjasEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'FlutterNinjas Tokyo 2024';
	String get description => 'An international Flutter conference in Tokyo Japan on Jun 13-14th 2024. See you in 2025.';
	String get dateDescription => 'June 2024';
}

// Path: join.joinSteps
class _StringsJoinJoinStepsEn {
	_StringsJoinJoinStepsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final _StringsJoinJoinStepsStep01En step01 = _StringsJoinJoinStepsStep01En._(_root);
	late final _StringsJoinJoinStepsStep02En step02 = _StringsJoinJoinStepsStep02En._(_root);
	late final _StringsJoinJoinStepsStep03En step03 = _StringsJoinJoinStepsStep03En._(_root);
}

// Path: qa.qaList.0
class _StringsQa$qaList$0i0$En with QAModel {
	_StringsQa$qaList$0i0$En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	@override String get q => 'I am a beginner, is it okay to join Flutter Daigaku?';
	@override String get a => 'Yes, it is. At Flutter Daigaku, we offer support for beginners to intermediate level learners.';
}

// Path: qa.qaList.1
class _StringsQa$qaList$0i1$En with QAModel {
	_StringsQa$qaList$0i1$En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	@override String get q => 'Should beginners start with HTML and other technologies?';
	@override String get a => 'No, they should start with Flutter. While it\'s always helpful to have prior knowledge, many individuals who started with Flutter are now active contributors to the field.';
}

// Path: qa.qaList.2
class _StringsQa$qaList$0i2$En with QAModel {
	_StringsQa$qaList$0i2$En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	@override String get q => 'Is it okay to use Windows?';
	@override String get a => 'Yes, it is. However, please note that you cannot debug iPhone apps on Windows, so a Mac is recommended for that purpose.';
}

// Path: qa.qaList.3
class _StringsQa$qaList$0i3$En with QAModel {
	_StringsQa$qaList$0i3$En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	@override String get q => 'What sets you apart from your competitors?';
	@override String get a => 'We are confident in the quality of our members. Flutter Daigaku has been evolving with our members since its launch in April 2020.';
}

// Path: qa.qaList.4
class _StringsQa$qaList$0i4$En with QAModel {
	_StringsQa$qaList$0i4$En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	@override String get q => 'Is there a point for active engineers to join?';
	@override String get a => 'Actually the 70% of members are Software engineer right now. So many join to make connections with fellow engineers. Join our community plan and create connections through study groups, joint development, online events, offline events, and other projects.';
}

// Path: qa.qaList.5
class _StringsQa$qaList$0i5$En with QAModel {
	_StringsQa$qaList$0i5$En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	@override String get q => 'Where can I contact for inquiries after joining?';
	@override String get a => 'Please use the inquiry page on the Flutter Daigaku app.';
}

// Path: qa.qaList.6
class _StringsQa$qaList$0i6$En with QAModel {
	_StringsQa$qaList$0i6$En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	@override String get q => 'What are the payment methods?';
	@override String get a => 'We support credit card payments (VISA, JCB, MASTER, AMEX). You will be charged on a monthly basis starting from the day you join.';
}

// Path: qa.qaList.7
class _StringsQa$qaList$0i7$En with QAModel {
	_StringsQa$qaList$0i7$En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	@override String get q => 'Can corporations also use this?';
	@override String get a => 'There are use cases for corporations as well. For more details, please contact us through the inquiry form at the bottom right.';
}

// Path: qa.qaList.8
class _StringsQa$qaList$0i8$En with QAModel {
	_StringsQa$qaList$0i8$En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	@override String get q => 'How do I withdraw my membership?';
	@override String get a => 'You can easily withdraw your membership through a single button on the inquiry page of the Flutter Daigaku app. No need for complicated phone inquiries.';
}

// Path: people.peoples.kosuke
class _StringsPeoplePeoplesKosukeEn {
	_StringsPeoplePeoplesKosukeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get name => 'Kosuke Saigusa';
	String get nickname => 'Kosuke';
	String get company => 'Ubie, Inc.';
	String get role => 'Study Meetup Leader';
	String get description => 'Born in 1995, from Fukuoka Prefecture. Graduated from Kyushu University with a degree in Mechanical and Aerospace Engineering. After graduation, worked at Siemens’ research facility in Belgium, focusing on machine learning. Later became a Web and Flutter engineer, working at Atama Plus Co., Ltd., SODA Inc., and currently employed at Omiai Co., Ltd. Spoke at FlutterKaigi 2023 and FlutterNinjas 2024. Developer of multiple pub packages. Let’s enjoy learning technology together!';
}

// Path: people.peoples.daigo
class _StringsPeoplePeoplesDaigoEn {
	_StringsPeoplePeoplesDaigoEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get name => 'Daigo Wakabayashi';
	String get nickname => 'Daigo';
	String get company => 'Freelance';
	String get role => 'Online Meetup Leader';
	String get description => 'Born in 1998 in Osaka. After graduating from Osaka University of Health and Sport Sciences, he joined UNIQLO. In October 2020, he resigned from UNIQLO to become a disciple of KBOY and moved from Osaka to Sapporo to assist in the development of Flutter-based apps. After a one-year training period, he has been working as a freelance Flutter engineer since October 2021 and has participated in several app development projects, including idol-related projects. He is active in various fields at Flutter Daigaku, such as organizing online social gatherings and managing Flutter Gakkai. He is known for his easy-to-understand advice and article writing as a presence close to beginners in teaching. Let\'s work hard together, beginners!';
}

// Path: people.peoples.kboy
class _StringsPeoplePeoplesKboyEn {
	_StringsPeoplePeoplesKboyEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get name => 'Kei Fujikawa';
	String get nickname => 'kboy';
	String get company => 'KBOY Inc. CEO';
	String get role => 'Founder';
	String get description => 'Born in 1991, from Sapporo. Graduated from Waseda University\'s School of Creative Science and Engineering, Department of Mechanical Engineering. After experiencing the role of development director for a flea market app at Proto Corporation, he transitioned to engineering and worked on \'NewsDigest\' at JX Press Corp and the AR app \'Pechabato\' at Graffity. After a year and a half as a freelancer, he founded KBOY Inc. in June 2020. Achieving 20,000 subscribers on YouTube and TikTok, which he had been doing since his freelance days, he started the Flutter Daigaku service with great enthusiasm. Let\'s work together to create successful apps!';
}

// Path: people.peoples.masaki
class _StringsPeoplePeoplesMasakiEn {
	_StringsPeoplePeoplesMasakiEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get name => 'Masaki Satoh';
	String get nickname => 'Masaki';
	String get company => 'Freelance';
	String get role => 'Personal Development Project Leader';
	String get description => 'Born in 1995 in Aichi Prefecture. Graduated from the International Japanese Studies Department at Meiji University. During his studies, he experienced an overseas internship at AIESEC Japan, where he also worked on marketing for an English education startup in Taiwan. After that, he worked on several service start-ups with his university friends, but they all failed. In the meantime, he made a living by working for Uber Eats, among others. Currently, he is a freelance Flutter engineer and is developing his own app. Let\'s use Flutter to bring your ideas to life together!';
}

// Path: people.peoples.uetomo
class _StringsPeoplePeoplesUetomoEn {
	_StringsPeoplePeoplesUetomoEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get name => 'Tomohiro Ueno';
	String get nickname => 'Uetomo';
	String get company => 'Freelance';
	String get role => 'Event Coordinator';
	String get description => 'Born in 1993 in Yamagata Prefecture. He devoted himself to baseball during his student years and achieved Best 8 in the National Softball Baseball Championship and participated in the National Sports Festival. After working at a water supply company and serving as the deputy manager of a ramen shop, he decided to learn programming because a friend from his hometown started a business related to IT. He studied abroad on Cebu Island to learn programming. Currently, he is working as a Flutter engineer. He loves fun things, so let\'s deepen our connections as engineers and have fun together!';
}

// Path: people.peoples.tokkuu
class _StringsPeoplePeoplesTokkuuEn {
	_StringsPeoplePeoplesTokkuuEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get name => 'Shinnosuke Tokuda';
	String get nickname => 'tokkuu';
	String get company => 'Mercari, Inc.';
	String get role => 'AWS and LINE Specialist';
	String get description => 'Born in 1991, from Fukuoka. After graduating from Kyushu University\'s Faculty of Science, Department of Physics, he worked as an infrastructure engineer at a Tokyo-based SIer (System Integrator) for 5 years. He then joined Milogos Inc., after that, he joined CyberAgent, Inc. where he is currently engaged as a full-stack engineer, handling frontend, backend, infrastructure, and project management. His favorite technologies are Flutter, Next.js, Node.js, AWS CDK, AWS Lambda, and Firebase. During his university days, he independently released two albums as a band member, conducted tours, and also gained experience as a cram school tutor and private tutor, which fostered his love for teaching.';
}

// Path: people.peoples.cobo
class _StringsPeoplePeoplesCoboEn {
	_StringsPeoplePeoplesCoboEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get name => 'Nozomi Kobayashi';
	String get nickname => 'cobo';
	String get company => 'Cloud Ace';
	String get role => 'Instructor';
	String get description => 'Born in 1998, hailing from Iwate Prefecture. After graduating from a two-year Information Technology College, he joined an SIer (System Integrator) in the same prefecture and was involved in the development of electronic medical record systems for four years. He then moved to Tokyo to expand his network among engineers and broaden his technical expertise, and is currently learning Google Cloud skills at Cloud Ace Inc. His hobbies include playing guitar, singing, and music production. He produces the background music for kboy\'s YouTube videos. He strives to create an enjoyable learning environment!';
}

// Path: people.peoples.gan
class _StringsPeoplePeoplesGanEn {
	_StringsPeoplePeoplesGanEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get name => 'Ryota Iwamoto';
	String get nickname => 'gan';
	String get company => 'Freelance';
	String get role => 'Instructor';
	String get description => 'Born in 2000, from Saitama Prefecture. Graduated from the Mathematics Program of the Faculty of Science at Niigata University. Currently in the second year of the Master\'s program at the same university, researching the theory of applied mathematics (asymptotic behavior in convex analysis). Since April 2021, working as a freelancer on the development of the Flutter-made NPO support application, \'Aidl\'. Hosted the Niigata off-meetup in February 2023 at Flutter Daigaku. My hobby is badminton. I will do my best to communicate closely with learners!';
}

// Path: people.peoples.ota
class _StringsPeoplePeoplesOtaEn {
	_StringsPeoplePeoplesOtaEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get name => 'Ota Ryunosuke';
	String get nickname => 'ryu';
	String get company => 'VISIONARY JAPAN';
	String get role => 'Instructor';
	String get description => 'Born in Shizuoka Prefecture in 1991. I transitioned from a completely different industry to a startup company through self-study. I work as a Flutter engineer, engaged in the development of a B2B-oriented customer success specialist service using Flutter web and Firebase. Currently, I am involved in various projects at VISIONARY JAPAN Inc. As a result of my personal development, I released a health management application for rabbits, \'Rabbit Diary\'. It was featured in a magazine called \'The Feelings of Rabbits\'. I will do my best to provide development support that caters to beginners!';
}

// Path: people.peoples.heyhey
class _StringsPeoplePeoplesHeyheyEn {
	_StringsPeoplePeoplesHeyheyEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get name => 'Shohei Ogawa';
	String get nickname => 'heyhey';
	String get company => 'Money Forward';
	String get role => 'Leading the community';
	String get description => 'Born in Kanazawa, 1984. Lived around the world until coming back to Japan for high school. Graduated Sophia University, Department of Comparative Culture. Made a transition to Software Developer, after 10 years of experience as a Sales in Food industry. After working 4 years as a Mobile application developer at Food tech Startup, joined MoneyForward inc. in May, 2023. Late bloomer whose only strength is in English and Flutter. Have used Flutter/Dart/Firebase/Node.js/Typescript. Into technologies related to AI and Web3 these days.';
}

// Path: people.peoples.minn
class _StringsPeoplePeoplesMinnEn {
	_StringsPeoplePeoplesMinnEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get name => 'Shiori Kitayama';
	String get nickname => 'minn';
	String get company => 'PLUGO';
	String get role => 'Instructor';
	String get description => 'Born in 2001, hailing from Aomori Prefecture. After graduating high school, I moved to Tokyo and started working as a general administrative staff at Sler Corporation. It was a colleague\'s recommendation that sparked my interest in programming, leading me to develop and release a personal project - an image collection app. In July 2022, I made a career change from being inexperienced to becoming a Flutter engineer. And then, I\'m actively involved in various projects at AxiaWorksLLC. After that, I ended up working at PLUGO. My daily motivation is to strive to become a competent, stylish female engineer. Let\'s enjoy learning and grow together!';
}

// Path: people.peoples.odaken
class _StringsPeoplePeoplesOdakenEn {
	_StringsPeoplePeoplesOdakenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get name => 'Tsurugi Oda';
	String get nickname => 'odaken';
	String get company => 'Freelance';
	String get role => 'Instructor';
	String get description => 'Born in 1998. Originally from Saga Prefecture. Graduated from Senshu University\'s Faculty of Business Administration, Department of Business Administration. From elementary school to university, he was dedicated to rugby and achieved a 4th place finish at the national athletic meet. After graduating from university, he started his career as a network engineer and, after experiencing three different companies, he is now active as a Flutter engineer. He has been involved in the development of a Flutter-based NPO support app called "Aidol" and is serving as an instructor at Techford Academy. He strives to convey the joy of app development!';
}

// Path: people.peoples.miyajic
class _StringsPeoplePeoplesMiyajicEn {
	_StringsPeoplePeoplesMiyajicEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get name => 'Kou Miyaji';
	String get nickname => 'miyajic';
	String get company => 'SODA inc.';
	String get role => 'Instructor';
	String get description => 'Born in 1997 in Aichi Prefecture, I graduated from the Graduate School of Information Science and Technology at Hokkaido University. Currently, I am working as a smartphone app engineer at TeamLab Inc., having joined the company as a new graduate. Since my student days, I have been involved with Flutter University, where I came up with the idea for "Suki Machi" and am continuing its development. I am excited to support fun learning and development experiences for others!';
}

// Path: people.peoples.aoi
class _StringsPeoplePeoplesAoiEn {
	_StringsPeoplePeoplesAoiEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get name => 'Yuta Azuma';
	String get nickname => 'Aoi Umigishi';
	String get company => 'Freelance';
	String get role => 'Instructor';
	String get description => 'Born in 1992 in Chiba. After graduating from the Graduate School of Fundamental Science and Engineering at Waseda University, he joined Trans Cosmos Co., Ltd. and worked as a mechanical parts design engineer using 3D CAD. He left the company because he wanted someone, somewhere in the world to smile because of the app he created. After half a year of developing individual apps, he became a freelance engineer by releasing five Flutter apps. He also manages and writes articles for the Flutter Daigaku\'s own media, "Weekly Flutter Daigaku." Let us assist you in becoming a "self-driving" engineer!';
}

// Path: people.peoples.naoki
class _StringsPeoplePeoplesNaokiEn {
	_StringsPeoplePeoplesNaokiEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get name => 'Naoki Wakata';
	String get nickname => 'Wakanao';
	String get company => 'Retty Inc.';
	String get role => 'A star among indie developers';
	String get description => 'Born in 1998. Hailing from Hokkaido. Graduate of the Faculty of Agriculture at Hokkaido University. Favorite food: bananas.\nJoined Flutter Daigaku during university and started learning programming. After graduation, joined the company Retty and is currently striving as an Android engineer in the mobile app team. In personal development, operates an app related to Jiro-style ramen using Flutter, achieving a daily user count of 100.\nLet\'s learn app development together with joy!!';
}

// Path: people.peoples.kenty
class _StringsPeoplePeoplesKentyEn {
	_StringsPeoplePeoplesKentyEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get name => 'Ken Tokura';
	String get nickname => 'kenty';
	String get company => 'Freelance';
	String get role => 'Instructor';
	String get description => 'Born in 1997 in Saitama Prefecture. Graduated from the Future Robotics Department at Chiba Institute of Technology. After graduation, worked at Diamondhead Inc. for 3 years, engaged in the development of EC services for the apparel industry.\nSince 2024, transitioned to freelancing, active in various fields such as website development, Flutter apps (iOS, Android, Linux), and teaching.\nIn March 2024, appointed as the tech lead at One Archer Co., Ltd.\nActually, I haven\'t released any apps personally, so I\'m eager to learn and develop together with everyone! Stay tuned!';
}

// Path: people.peoples.fen
class _StringsPeoplePeoplesFenEn {
	_StringsPeoplePeoplesFenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get name => 'Kenshi Ueda';
	String get nickname => 'fen';
	String get company => 'Freelance';
	String get role => 'Instructor';
	String get description => 'Born in 2003, from Fukuoka Prefecture. Joined Flutter University in 2022, learning Flutter at places like the Flutter share house and Flutter villa, and now working as a freelancer. Started Flutter with no prior experience and faced many challenges along the way, which makes me eager to share knowledge and provide technical support! In my personal projects, I implement native-specific features using Flutter. My hobbies are Mahjong and Shogi!';
}

// Path: join.joinSteps.step01
class _StringsJoinJoinStepsStep01En {
	_StringsJoinJoinStepsStep01En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Sign up with GitHub';
}

// Path: join.joinSteps.step02
class _StringsJoinJoinStepsStep02En {
	_StringsJoinJoinStepsStep02En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Select plan\n& make payment';
}

// Path: join.joinSteps.step03
class _StringsJoinJoinStepsStep03En {
	_StringsJoinJoinStepsStep03En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => '1on1 zoom meeting on Slack';
	String get titleMobile => '1on1 zoom meeting \non Slack';
}

// Path: <root>
class _StringsJa extends Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsJa.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.ja,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super.build(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ja>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	@override late final _StringsJa _root = this; // ignore: unused_field

	// Translations
	@override late final _StringsWhyJa why = _StringsWhyJa._(_root);
	@override late final _StringsWorksJa works = _StringsWorksJa._(_root);
	@override late final _StringsAboutJa about = _StringsAboutJa._(_root);
	@override late final _StringsPlanJa plan = _StringsPlanJa._(_root);
	@override late final _StringsPriceJa price = _StringsPriceJa._(_root);
	@override late final _StringsIntervalJa interval = _StringsIntervalJa._(_root);
	@override String get cta_github => 'GitHubで始める';
	@override String get cta => 'メールアドレスで始める';
	@override String get cta_available_count1 => '現在あと';
	@override String get cta_available_count2 => '人受付中';
	@override String get cta_no_available => '今月は締め切りました';
	@override late final _StringsPeopleJa people = _StringsPeopleJa._(_root);
	@override late final _StringsVoiceJa voice = _StringsVoiceJa._(_root);
	@override late final _StringsProjectsJa projects = _StringsProjectsJa._(_root);
	@override late final _StringsMediaJa media = _StringsMediaJa._(_root);
	@override late final _StringsJoinJa join = _StringsJoinJa._(_root);
	@override late final _StringsQaJa qa = _StringsQaJa._(_root);
	@override late final _StringsMessageJa message = _StringsMessageJa._(_root);
	@override late final _StringsNewMembersJa newMembers = _StringsNewMembersJa._(_root);
	@override late final _StringsMenuJa menu = _StringsMenuJa._(_root);
	@override late final _StringsFooterJa footer = _StringsFooterJa._(_root);
	@override String get underMaintenance => '現在メンテナンス中です';
	@override late final _StringsScheduleJa schedule = _StringsScheduleJa._(_root);
}

// Path: why
class _StringsWhyJa extends _StringsWhyEn {
	_StringsWhyJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get why_flutter => 'なぜFlutterなのか？';
	@override String get description => 'Flutterは今すごい勢いで普及しています。開発元のGoogleや開発者コミュニティの勢い、そして少人数で高速に開発できる生産性の高さ、開発者UXの良さが評価され、ビジネスの現場でも急速に流行っています。Flutter大学はこのFlutterの魅力に共感し、2020年4月に始まり、以来日本のFlutterコミュニティを盛り上げてきました。今後は世界も視野に入れて、開発者が楽しく学習し、時に仕事を交換したり、アプリ開発の知見を共有できる世界を作っていきます。';
	@override String get learn_more => 'Flutterについてもっと詳しく知る';
}

// Path: works
class _StringsWorksJa extends _StringsWorksEn {
	_StringsWorksJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get member_development_record => 'メンバーの開発実績';
	@override String get released_ago => 'リリース';
	@override String get updated_ago => '更新';
	@override String get joint_development => '共同開発';
	@override String get individual_development => '個人開発';
}

// Path: about
class _StringsAboutJa extends _StringsAboutEn {
	_StringsAboutJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get three_features => 'Flutter大学3つの特徴';
	@override String get youtube_free => 'Flutter基礎講座をYouTubeで公開';
	@override String get ai_training => 'AIと人間講師に同時に聞ける';
	@override String get coach => '私たちが学習コーチをします。';
	@override String get learn_from_code => 'コードを読んで学べる';
	@override String get flutter_textbook => 'Flutterの教科書で学べる';
	@override String get joint_study_meeting => '共同勉強会でアウトプットできる';
	@override String get individual_development_presentation => '個人開発発表会でモチベを上げる';
	@override String get team_development => 'みんなでチーム開発ができる';
	@override String get engineer_introduction => 'エンジニア紹介もやってます';
	@override String get slack_interaction => 'Slackでの情報交換が盛ん';
	@override String get online_workroom => '作業部屋で集中できる';
	@override String get online_exchange_meeting => '交流会でエンジニア友達ができる';
	@override String get share_house_off_meeting => 'シェアハウス、オフ会で一生の仲間を';
	@override String get job_is_here => '仕事はここで見つかる';
	@override String get youtube_free_description => 'YouTubeチャンネル「Flutter大学」で教材を無料公開しています。Flutterの基礎が動画で学べるので、実はこれだけでアプリが作れるようになる方もいらっしゃいます。';
	@override String get ai_training_description => 'AI修行プランでは、最新のAIモデルGemini 2.5 Proに無制限で質問ができます。24時間いつでも即座に回答が得られ、必要に応じて経験豊富な人間講師のサポートも受けられるため、Flutter学習を爆速で進められます。';
	@override String get learn_from_code_description => 'Flutter大学専用アプリや共同開発で作られたアプリの生のコードをGithubで閲覧できます。providerやriverpodを使った状態管理の仕方や位置情報アプリの作り方などを実際のコードを参考にして進めることができます。このLPのFlutter Webのコードも全部見れます。';
	@override String get flutter_textbook_description => '月4,400円の課題学習プラン以上の方は、Flutter大学限定オリジナル教材「Flutterの教科書」や「【リリースまで学べる】位置情報APIを使ったFlutterアプリ開発」を閲覧することができます。その場合、zennで別途購入する必要はございません。教材は随時追加していきます！';
	@override String get joint_study_meeting_description => 'メンバーの有志で水曜日の21時から共同勉強会を行っています。メンバーが週替わりでFlutterの知見を発表したり、NotionやAIの話題など内容は多岐に渡ります。';
	@override String get individual_development_presentation_description => '個人開発の成果を発表する発表会が月１回行われています。自分の使ったアプリを人に知ってもらう機会にもなるし、締切効果でモチベもキープできます。みんなが何を考えて開発しているか、コードだけじゃなくマーケティングも学ぶ良い機会になります。';
	@override String get team_development_description => '３ヶ月ごとにチームを結成し、共同開発を行っています！3ヶ月に1回キックオフを行います。その際アイデアを持つ人がアプリのアイデアを発表し、賛同するものは参加を表明してチームを結成するというルールです。キックオフは1月、4月、7月、10月に行っています。';
	@override String get engineer_introduction_description1 => 'Flutter大学では、Flutterエンジニアをお探しの方からのご連絡を受け付けています。Flutter大学に参加しているエンジニア';
	@override String get engineer_introduction_description2 => '人の中から、条件に合うエンジニアをご紹介することができます。';
	@override String get slack_interaction_description => 'Flutterの情報交換はもちろん最新AIの動向やエンジニアならではのキャリア談義から海外進出の話まで様々な会話が行われています。１日見ないだけでSlackの未読が大量にたまります。';
	@override String get online_workroom_description => 'GatherやMetaLifeを用いたオンライン作業部屋を用意しています。朝のもくもく会からMTG、オンライン飲み会まで、自由に使われています。';
	@override String get online_exchange_meeting_description => 'zoomを用いたオンライン交流会を月に1回行っています。ここで出来たつながりで仕事の話が舞い込んだり、実は同じ出身地で盛り上がったり、素晴らしい交流の機会です。';
	@override String get share_house_off_meeting_description => '東京恵比寿にシェアハウス「フラハ」、滋賀県東近江市に古民家「Flutter別荘」があり、Flutter大学メンバーが住んでいます。また、オフ会は、東京、札幌、名古屋、大阪、福岡などで２ヶ月に１回ペースで行なっています。やはりオフラインでの交流は濃い話もでき、オンラインには変え難いものです。';
	@override String get job_is_here_description => 'FlutterWork経由での仕事はslackにてシェアされ、メンバーは応募することができます。運営によるチェックの後、条件があえば企業さんとマッチングします。お互いにコミュニケーション能力や技術力がわかっていて、信頼関係があるからこそスムーズな仕事の紹介が成り立っています。';
	@override String get youtube_free_button => 'YouTube「Flutter大学」';
	@override String get ai_training_button => 'AI修行プランとは？';
	@override String get learn_from_code_button => 'GitHub「Flutter大学」';
	@override String get flutter_textbook_button => 'zenn本「Flutterの教科書」';
	@override String get joint_study_meeting_button => '共同勉強会のまとめ記事';
	@override String get individual_development_presentation_button => '個人開発発表会とは？';
	@override String get team_development_button => '共同開発とは？';
	@override String get engineer_introduction_button => 'Flutterエンジニアをお探しの企業様はこちら';
	@override String get slack_interaction_button => 'Flutter大学の活用法 〜 Slack 編〜';
	@override String get online_workroom_button => 'オンライン作業部屋とは？';
	@override String get online_exchange_meeting_button => 'オンライン交流会とは？';
	@override String get share_house_off_meeting_button => 'Flutter別荘のTwitter';
	@override String get mentor_plans => 'ここだけの学習指導プラットフォーム';
	@override String get mentor_plans_description => '「CodeBoy2」と呼ばれる、Flutter大学内で講師にマンツーマンで指導をしてもらえるプラットフォームがあります。講師はFlutter大学メンバーで、4~10%という破格の手数料のみで、指導、メンター活動を行うことができ、学習者はFlutter大学内の優秀なエンジニアの方々の指導をマンツーマンで受けることができます。都度決済なので、どのプランの方でもお使いいただけます。マンツーマンで学習指導を受けたい方、すでに他社プラットフォームさんで学習メンターをされてる講師の方におすすめの機能です。';
}

// Path: plan
class _StringsPlanJa extends _StringsPlanEn {
	_StringsPlanJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get community => 'コミュニティプラン';
	@override String get learning => '課題学習プラン';
	@override String get trainingLight => 'ライト修行プラン';
	@override String get training => '修行プラン';
	@override String get aiTraining => 'AI修行プラン';
}

// Path: price
class _StringsPriceJa extends _StringsPriceEn {
	_StringsPriceJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override late final _StringsPriceLPDescriptionJa lPDescription = _StringsPriceLPDescriptionJa._(_root);
	@override String get lPFeature1 => '・初回1on1MTG\n・Flutter大学Slack参加\n・GitHub Organization参加\n・共同開発への参加\n・共同勉強会の閲覧・発表\n・アーカイブ動画閲覧\n・オンライン交流会\n・オフ会';
	@override String get lPFeature2 => 'コミュニティの全機能に加えて\n・限定教材での学習';
	@override String get lPFeature3 => '課題学習の全機能に加えて\n・ライトサポート付き';
	@override String get lPFeature4 => '課題学習の全機能に加えて\n・フルサポート付き\n・GitHubでテキスト質問可能\n・2,860円のFlutter入門書プレゼント';
	@override String get lPFeature5 => '課題学習の全機能に加えて\n・Gemini 2.5 Proに質問し放題\n・モバイル歴10年の人間講師もサポート\n・2,860円のFlutter入門書プレゼント';
	@override String get yen => '円';
	@override String get yen_per_month => ' 円 / 月';
	@override String get month => '月';
	@override String get threeMonth => '3ヶ月';
	@override String get sixMonth => '6ヶ月';
	@override String get year => '年';
	@override String get if_convert_to_month => '月に換算すると';
	@override String get threeMonthsOff => '3ヶ月分OFF!!';
}

// Path: interval
class _StringsIntervalJa extends _StringsIntervalEn {
	_StringsIntervalJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get monthly => '月額';
	@override String get threeMonth => '3ヶ月';
	@override String get sixMonth => '6ヶ月';
	@override String get annual => '年額';
}

// Path: people
class _StringsPeopleJa extends _StringsPeopleEn {
	_StringsPeopleJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get subtitle1 => '講師陣';
	@override String get subtitle2 => '活躍しているメンバー';
	@override String get other1 => 'その他合計で';
	@override String get other2 => '名が参加中！';
	@override String get slackAPI => '※毎時間Slack APIで人数を集計';
	@override late final _StringsPeoplePeoplesJa peoples = _StringsPeoplePeoplesJa._(_root);
}

// Path: voice
class _StringsVoiceJa extends _StringsVoiceEn {
	_StringsVoiceJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get description => 'Flutter大学について書かれた\nnoteやブログをご紹介します。';
}

// Path: projects
class _StringsProjectsJa extends _StringsProjectsEn {
	_StringsProjectsJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get subtitle => 'メンバーによる様々な取り組み';
	@override late final _StringsProjectsFlutterHouseJa flutter_house = _StringsProjectsFlutterHouseJa._(_root);
	@override late final _StringsProjectsFlutterGakkaiJa flutter_gakkai = _StringsProjectsFlutterGakkaiJa._(_root);
	@override late final _StringsProjectsWeeklyFlutterUniversityJa weekly_flutter_university = _StringsProjectsWeeklyFlutterUniversityJa._(_root);
	@override late final _StringsProjectsHackathonVictoryJa hackathon_victory = _StringsProjectsHackathonVictoryJa._(_root);
	@override late final _StringsProjectsFlutterVillaJa flutter_villa = _StringsProjectsFlutterVillaJa._(_root);
	@override late final _StringsProjectsFlutterWomenJa flutter_women = _StringsProjectsFlutterWomenJa._(_root);
	@override late final _StringsProjectsXxDartJa xx_dart = _StringsProjectsXxDartJa._(_root);
	@override late final _StringsProjectsMorningMokumokuJa morning_mokumoku = _StringsProjectsMorningMokumokuJa._(_root);
	@override late final _StringsProjectsTokyoFlutterHackathonJa tokyo_flutter_hackathon = _StringsProjectsTokyoFlutterHackathonJa._(_root);
	@override late final _StringsProjectsTerakoyaJa terakoya = _StringsProjectsTerakoyaJa._(_root);
	@override late final _StringsProjectsFlutterBookJa flutter_book = _StringsProjectsFlutterBookJa._(_root);
	@override late final _StringsProjectsGlobalGamersChallengeJa global_gamers_challenge = _StringsProjectsGlobalGamersChallengeJa._(_root);
	@override late final _StringsProjectsFlutterNinjasJa flutter_ninjas = _StringsProjectsFlutterNinjasJa._(_root);
}

// Path: media
class _StringsMediaJa extends _StringsMediaEn {
	_StringsMediaJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get subtitle => 'メディア掲載';
}

// Path: join
class _StringsJoinJa extends _StringsJoinEn {
	_StringsJoinJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get subtitle => '入学の流れ';
	@override late final _StringsJoinJoinStepsJa joinSteps = _StringsJoinJoinStepsJa._(_root);
}

// Path: qa
class _StringsQaJa extends _StringsQaEn {
	_StringsQaJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get subtitle => 'よくある質問';
	@override List<QAModel> get qaList => [
		_StringsQa$qaList$0i0$Ja._(_root),
		_StringsQa$qaList$0i1$Ja._(_root),
		_StringsQa$qaList$0i2$Ja._(_root),
		_StringsQa$qaList$0i3$Ja._(_root),
		_StringsQa$qaList$0i4$Ja._(_root),
		_StringsQa$qaList$0i5$Ja._(_root),
		_StringsQa$qaList$0i6$Ja._(_root),
		_StringsQa$qaList$0i7$Ja._(_root),
		_StringsQa$qaList$0i8$Ja._(_root),
	];
}

// Path: message
class _StringsMessageJa extends _StringsMessageEn {
	_StringsMessageJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'Flutter大学コミュニティの価値とは？';
	@override String get message => '技術の急速な進歩により、アプリ開発の手法は日々変化していますが、Flutter大学では単なる技術習得を超えた価値を大切にしています。\n\n私たちが最も重視するのは、メンバー一人ひとりが互いの成長を支え合う「学び合いのコミュニティ」です。\n\n質問や課題を一人で抱え込むのではなく、経験豊富なメンバーが惜しみなく知識を共有し、初心者の方でも安心して学習を進められる環境を築いてきました。\n\n共同開発やオンライン勉強会を通じて、個人の学習だけでは得られない実践的なスキルと、何よりも貴重な人とのつながりを育んでいます。\n\n私たちと一緒に、技術と人とのつながりを大切にした学習コミュニティを築いていきませんか？\n\nFlutter大学代表\n藤川慶';
}

// Path: newMembers
class _StringsNewMembersJa extends _StringsNewMembersEn {
	_StringsNewMembersJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get dayAgo => '日前';
	@override String get hourAgo => '時間前';
	@override String get minuteAgo => '分前';
	@override String get secondAgo => '秒前';
	@override String get future => '将来的';
	@override String get ni => 'に、';
	@override String get joined => 'さんが入会しました！';
}

// Path: menu
class _StringsMenuJa extends _StringsMenuEn {
	_StringsMenuJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get developmentExperience => '開発実績';
	@override String get threeFeatures => '3つの特徴';
	@override String get pricePlan => '料金プラン';
	@override String get members => 'メンバー';
	@override String get memberVoice => 'メンバーの声';
	@override String get enrollmentProcess => '入学の流れ';
	@override String get faq => 'よくある質問';
	@override String get login => 'ログイン';
}

// Path: footer
class _StringsFooterJa extends _StringsFooterEn {
	_StringsFooterJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get terms => '利用規約';
	@override String get tokusho => '特定商取引法に基づく表記';
	@override String get privacyPolicy => 'プライバシーポリシー';
	@override String get operatingCompany => '運営会社';
}

// Path: schedule
class _StringsScheduleJa extends _StringsScheduleEn {
	_StringsScheduleJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'スケジュール予約';
	@override String get description => 'AIと人間講師に同時に聞ける\n個別相談やメンタリングのスケジュール予約は\nCalendlyページから行ってください。';
	@override String get calendlyButton => 'Calendlyで予約する';
}

// Path: price.lPDescription
class _StringsPriceLPDescriptionJa extends _StringsPriceLPDescriptionEn {
	_StringsPriceLPDescriptionJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get community => '全てのエンジニア向け\nコミュニティを活用しよう！';
	@override String get learning => '独学でFlutter学習する方向け\n限定教材を活用しよう！';
	@override String get trainingLight => 'ちょっと質問したい人向け\n月4回だけ質問できます！';
	@override String get training => '爆速で成長したい人向け\nたくさん質問しよう！';
	@override String get aiTraining => '爆速で成長したい人向け\nAIと人間講師に同時に聞ける！';
}

// Path: people.peoples
class _StringsPeoplePeoplesJa extends _StringsPeoplePeoplesEn {
	_StringsPeoplePeoplesJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override late final _StringsPeoplePeoplesKosukeJa kosuke = _StringsPeoplePeoplesKosukeJa._(_root);
	@override late final _StringsPeoplePeoplesDaigoJa daigo = _StringsPeoplePeoplesDaigoJa._(_root);
	@override late final _StringsPeoplePeoplesKboyJa kboy = _StringsPeoplePeoplesKboyJa._(_root);
	@override late final _StringsPeoplePeoplesMasakiJa masaki = _StringsPeoplePeoplesMasakiJa._(_root);
	@override late final _StringsPeoplePeoplesUetomoJa uetomo = _StringsPeoplePeoplesUetomoJa._(_root);
	@override late final _StringsPeoplePeoplesTokkuuJa tokkuu = _StringsPeoplePeoplesTokkuuJa._(_root);
	@override late final _StringsPeoplePeoplesCoboJa cobo = _StringsPeoplePeoplesCoboJa._(_root);
	@override late final _StringsPeoplePeoplesGanJa gan = _StringsPeoplePeoplesGanJa._(_root);
	@override late final _StringsPeoplePeoplesOtaJa ota = _StringsPeoplePeoplesOtaJa._(_root);
	@override late final _StringsPeoplePeoplesHeyheyJa heyhey = _StringsPeoplePeoplesHeyheyJa._(_root);
	@override late final _StringsPeoplePeoplesMinnJa minn = _StringsPeoplePeoplesMinnJa._(_root);
	@override late final _StringsPeoplePeoplesOdakenJa odaken = _StringsPeoplePeoplesOdakenJa._(_root);
	@override late final _StringsPeoplePeoplesMiyajicJa miyajic = _StringsPeoplePeoplesMiyajicJa._(_root);
	@override late final _StringsPeoplePeoplesAoiJa aoi = _StringsPeoplePeoplesAoiJa._(_root);
	@override late final _StringsPeoplePeoplesNaokiJa naoki = _StringsPeoplePeoplesNaokiJa._(_root);
	@override late final _StringsPeoplePeoplesKentyJa kenty = _StringsPeoplePeoplesKentyJa._(_root);
	@override late final _StringsPeoplePeoplesFenJa fen = _StringsPeoplePeoplesFenJa._(_root);
}

// Path: projects.flutter_house
class _StringsProjectsFlutterHouseJa extends _StringsProjectsFlutterHouseEn {
	_StringsProjectsFlutterHouseJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'Flutterハウス';
	@override String get description => 'Flutterハウスは、こんぶさんが立ち上げたFlutterエンジニアによるFlutterエンジニアのためのシェアハウス。某恋愛リアリティショーを意識して「フラハ」と呼ばれています。東京恵比寿にあるアパートの１室で4~6人のエンジニアが暮らしていて、仕事から遊びまで全力で楽しんでいます。月１でUTAGEと呼ばれる飲み会も開催中。Flutter大学メンバーが気軽に立ち寄れる東京の拠点です。';
	@override String get dateDescription => '2020年10月~';
}

// Path: projects.flutter_gakkai
class _StringsProjectsFlutterGakkaiJa extends _StringsProjectsFlutterGakkaiEn {
	_StringsProjectsFlutterGakkaiJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'FlutterGakkai';
	@override String get description => 'FlutterGakkaiは、Flutterエンジニアのための勉強会です。以前からFlutter大学内では共同勉強会を行っていましたが、Flutter大学内に止まらず日本のFlutter界隈を盛り上げようということで立ち上がったオンライン勉強会です。今まで２回オンラインで開催しました。将来的にはオフラインで大々的に開催することを目指しています。';
	@override String get dateDescription => '2022年1月~';
}

// Path: projects.weekly_flutter_university
class _StringsProjectsWeeklyFlutterUniversityJa extends _StringsProjectsWeeklyFlutterUniversityEn {
	_StringsProjectsWeeklyFlutterUniversityJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '週刊Flutter大学';
	@override String get description => '週刊Flutter大学は、Aoiさんが編集長として始めたWEBメディアです。毎週更新される「今週のFlutterニュース」では常にFlutterの最新情報をキャッチアップできます。また、Flutter公式の最新リリースの際には最速で日本語まとめ記事をリリースしており、日本のFlutterメディアを牽引しています。';
	@override String get dateDescription => '2022年3月~';
}

// Path: projects.hackathon_victory
class _StringsProjectsHackathonVictoryJa extends _StringsProjectsHackathonVictoryEn {
	_StringsProjectsHackathonVictoryJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ハッカソン優勝';
	@override String get description => 'Flutter大学内でチームを組んでハッカソンに出場しています。先日行われたSpajam2022第一回予選ではFlutterLoversが最優秀賞を獲得しました。Flutter×Firebaseのスキルセットは、開発スピードが早く、ハッカソン向きだと思われます。今後もその他のチームの出場予定があり期待が高まります。';
	@override String get dateDescription => '2022年8月';
}

// Path: projects.flutter_villa
class _StringsProjectsFlutterVillaJa extends _StringsProjectsFlutterVillaEn {
	_StringsProjectsFlutterVillaJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'Flutter別荘';
	@override String get description => 'Flutter別荘は、こんぶさんが滋賀県東近江市の古民家を購入したことによりスタートしました。Flutterハウスに次ぐ第２のシェアハウスでもあり、今後Flutter合宿を行う拠点としても期待されています。庭には手作りサウナ小屋があり、車庫にパワーラックを持つジムがあり、そして高速Wifiもございます。事前に連絡することで泊まりにいくことが可能です。';
	@override String get dateDescription => '2022年8月~';
}

// Path: projects.flutter_women
class _StringsProjectsFlutterWomenJa extends _StringsProjectsFlutterWomenEn {
	_StringsProjectsFlutterWomenJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'Flutter女子';
	@override String get description => 'Flutter大学の女子メンバーが定期的に集まって女子会をしたり、アプリ開発を行っています。現在、Flutter女子チームでクリスマスに向けたアプリを共同開発中！';
	@override String get dateDescription => '2022年10月~';
}

// Path: projects.xx_dart
class _StringsProjectsXxDartJa extends _StringsProjectsXxDartEn {
	_StringsProjectsXxDartJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '〇〇.dart';
	@override String get description => '「地域×Flutter」というコンセプトのもと、〇〇.dartというFlutter勉強会を開催しています。Flutter大学に入っている人だけでなく、興味のある方々にも参加していただけます。5月には大阪.dart、6月には東京.dartが開催される予定です。北海道.dartも8月のビアガーデンシーズンに開催予定です。';
	@override String get dateDescription => '2023年3月~';
}

// Path: projects.morning_mokumoku
class _StringsProjectsMorningMokumokuJa extends _StringsProjectsMorningMokumokuEn {
	_StringsProjectsMorningMokumokuJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '朝のもくもく会';
	@override String get description => '入る場所は、gatherというバーチャル上のワークスペースです。毎朝7:10~8:00まで、gather上のテーブルで一緒にもくもくと作業をして、8:00になったら左下のテーブルに集まって、今日やったことを報告して終了です。早起きしてみんなで作業する習慣付けに活用しています。';
	@override String get dateDescription => '2023年4月~';
}

// Path: projects.tokyo_flutter_hackathon
class _StringsProjectsTokyoFlutterHackathonJa extends _StringsProjectsTokyoFlutterHackathonEn {
	_StringsProjectsTokyoFlutterHackathonJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '東京Flutterハッカソン';
	@override String get description => 'Flutter大学と株式会社ゆめみの共同で、「東京Flutterハッカソン」を9/30,10/1の2日間で開催しました。多くの企業さんにスポンサーに入っていただき、またサイバーエージェントさんの会場もお借りして開催することができました。参加者はなんと100人超えで参加チームは23チームにおよびました。';
	@override String get dateDescription => '2023年9月';
}

// Path: projects.terakoya
class _StringsProjectsTerakoyaJa extends _StringsProjectsTerakoyaEn {
	_StringsProjectsTerakoyaJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'テラコヤテック';
	@override String get description => 'テラコヤテックは、これからのエンジニアのスキルとして需要の高いツール・言語を6ヶ月で習得できる、エンジニア養成プログラムです。採択制。完全無料。リツアンSTCさんとクラウドテックさんとFlutter大学がコラボして行われました。';
	@override String get dateDescription => '2023年12月~2024年5月';
}

// Path: projects.flutter_book
class _StringsProjectsFlutterBookJa extends _StringsProjectsFlutterBookEn {
	_StringsProjectsFlutterBookJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ゼロから学ぶFlutterアプリ開発の出版';
	@override String get description => 'Flutter大学の創業者kboyが技術評論社からFlutterの入門書を出版しました。';
	@override String get dateDescription => '2023年12月';
}

// Path: projects.global_gamers_challenge
class _StringsProjectsGlobalGamersChallengeJa extends _StringsProjectsGlobalGamersChallengeEn {
	_StringsProjectsGlobalGamersChallengeJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'Global Gamers Challengeで日本優勝';
	@override String get description => 'Global Gamers ChallengeというFlutter公式が主催するハッカソンで、みやじっくさんとkazukiさんのチームが作ったTurtle escapeがGoogle Wallet - Best Integration in Japanese - 1st placeに輝き、7,500USDの賞金を獲得しました！';
	@override String get dateDescription => '2024年5月';
}

// Path: projects.flutter_ninjas
class _StringsProjectsFlutterNinjasJa extends _StringsProjectsFlutterNinjasEn {
	_StringsProjectsFlutterNinjasJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'FlutterNinjas Tokyo 2024';
	@override String get description => 'Flutter大学メンバーがオーガナイザーとなり、FlutterNinjasという日本初の英語のFlutterカンファレンスを開催しました。Riverpod開発者のRemiさんをはじめ、多くの著名なFlutterエンジニアが世界から集まりました。';
	@override String get dateDescription => '2024年6月';
}

// Path: join.joinSteps
class _StringsJoinJoinStepsJa extends _StringsJoinJoinStepsEn {
	_StringsJoinJoinStepsJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override late final _StringsJoinJoinStepsStep01Ja step01 = _StringsJoinJoinStepsStep01Ja._(_root);
	@override late final _StringsJoinJoinStepsStep02Ja step02 = _StringsJoinJoinStepsStep02Ja._(_root);
	@override late final _StringsJoinJoinStepsStep03Ja step03 = _StringsJoinJoinStepsStep03Ja._(_root);
}

// Path: qa.qaList.0
class _StringsQa$qaList$0i0$Ja extends _StringsQa$qaList$0i0$En with QAModel {
	_StringsQa$qaList$0i0$Ja._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get q => '初心者ですが、大丈夫ですか？';
	@override String get a => '大丈夫です。\nFlutter大学では初心者から中級者の方まで幅広くサポートしています。';
}

// Path: qa.qaList.1
class _StringsQa$qaList$0i1$Ja extends _StringsQa$qaList$0i1$En with QAModel {
	_StringsQa$qaList$0i1$Ja._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get q => '初心者はHTML等から始めるべきですか？';
	@override String get a => 'いいえ。Flutterから始めて大丈夫です。\nもちろん知っているに越したことはありませんがFlutterから始めてバリバリ活躍されている方も多いのでご安心ください。';
}

// Path: qa.qaList.2
class _StringsQa$qaList$0i2$Ja extends _StringsQa$qaList$0i2$En with QAModel {
	_StringsQa$qaList$0i2$Ja._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get q => 'Windowsですが、大丈夫ですか？';
	@override String get a => '大丈夫です。\nしかし、WindowsですとiPhoneアプリのデバッグができないのでMacの方がオススメです。';
}

// Path: qa.qaList.3
class _StringsQa$qaList$0i3$Ja extends _StringsQa$qaList$0i3$En with QAModel {
	_StringsQa$qaList$0i3$Ja._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get q => '競合他社との違いはなんですか？';
	@override String get a => 'メンバーの質で負けない自信があります。\nFlutter大学は2020年4月からスタートし、メンバーと共に進化を重ねてきました。';
}

// Path: qa.qaList.4
class _StringsQa$qaList$0i4$Ja extends _StringsQa$qaList$0i4$En with QAModel {
	_StringsQa$qaList$0i4$Ja._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get q => '現役エンジニアは入る意味ありますか？';
	@override String get a => '実はFlutter大学のメンバーの7割以上が現役エンジニアで、エンジニア仲間を作る目的で入られる方も多いです。\nコミュニティプランに入り、勉強会や共同開発、オンライン交流会、オフ会、その他のプロジェクトを通してエンジニア仲間を作りましょう！';
}

// Path: qa.qaList.5
class _StringsQa$qaList$0i5$Ja extends _StringsQa$qaList$0i5$En with QAModel {
	_StringsQa$qaList$0i5$Ja._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get q => '入会後のお問い合わせ先は？';
	@override String get a => 'Flutter大学アプリのお問い合わせページからお問い合わせください。';
}

// Path: qa.qaList.6
class _StringsQa$qaList$0i6$Ja extends _StringsQa$qaList$0i6$En with QAModel {
	_StringsQa$qaList$0i6$Ja._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get q => '決済方法について教えてください';
	@override String get a => 'クレジットカード(VISA, JCB, MASTER, AMEX)でのお支払いに対応しております。\n入会日を起点とし、１ヶ月ごとに定期決済されます。';
}

// Path: qa.qaList.7
class _StringsQa$qaList$0i7$Ja extends _StringsQa$qaList$0i7$En with QAModel {
	_StringsQa$qaList$0i7$Ja._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get q => '法人でも活用できますか？';
	@override String get a => '法人様の活用事例もございます。\n詳しくは右下のお問い合わせからご連絡をお願いいたします。';
}

// Path: qa.qaList.8
class _StringsQa$qaList$0i8$Ja extends _StringsQa$qaList$0i8$En with QAModel {
	_StringsQa$qaList$0i8$Ja._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get q => '退会方法は？';
	@override String get a => 'Flutter大学アプリのお問い合わせページからボタン一つで退会できます。\n面倒な電話問い合わせ等はございません。';
}

// Path: people.peoples.kosuke
class _StringsPeoplePeoplesKosukeJa extends _StringsPeoplePeoplesKosukeEn {
	_StringsPeoplePeoplesKosukeJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get name => '三枝 洸介';
	@override String get nickname => 'Kosuke';
	@override String get company => 'Ubie株式会社';
	@override String get role => '共同勉強会主催';
	@override String get description => '1995年生まれ。福岡県出身。九州大学工学部機械航空工学科卒。卒業後Siemens社のベルギー研究所で機械学習系の研究業務に従事。その後、Web,Flutterエンジニアとして、atama plus株式会社、株式会社SODA等を経て株式会社Omiaiで勤務中。FlutterKaigi 2023, FlutterNinjas 2024などで登壇。複数のpub パッケージの開発者。一緒に楽しく技術を学びましょう！';
}

// Path: people.peoples.daigo
class _StringsPeoplePeoplesDaigoJa extends _StringsPeoplePeoplesDaigoEn {
	_StringsPeoplePeoplesDaigoJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get name => '若林 大剛';
	@override String get nickname => 'ダイゴ';
	@override String get company => 'フリーランス（NPO支援「エイドル」開発他）';
	@override String get role => 'オンライン交流会主催';
	@override String get description => '1998年生まれ。大阪出身。大阪体育大学卒業後、ユニクロに入社。2020年10月、kboyに弟子入りするため、ユニクロを退職。大阪から札幌に移住し、Flutterを使ったアプリ開発を手伝う。１年間の修行期間を経て2021年10月からFlutterのフリーランスエンジニアとして活躍、エイドルを始め複数のアプリ開発プロジェクトに参画している。Flutter大学では、オンライン交流会の主催、FlutterGakkaiの運営など多角的に活動している。指導では、初心者に近い存在としてわかりやすいアドバイスや記事執筆に定評がある。初心者のみなさん一緒に頑張りましょう！';
}

// Path: people.peoples.kboy
class _StringsPeoplePeoplesKboyJa extends _StringsPeoplePeoplesKboyEn {
	_StringsPeoplePeoplesKboyJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get name => '藤川 慶';
	@override String get nickname => 'kboy';
	@override String get company => '株式会社KBOY代表取締役社長';
	@override String get role => '創設者';
	@override String get description => '1991年生まれ。札幌出身。早稲田大学創造理工学部総合機械工学科卒。プロトコーポレーションでフリマアプリの開発ディレクターを経験後エンジニアに転向し、JX通信社で「NewsDigest」、GraffityにてARアプリ「ペチャバト」の開発を経験。１年半のフリーランス期間を経て、2020年6月に現在の株式会社KBOYを創業。同時期にFlutter大学をスタート。「ゼロから学ぶFlutterアプリ開発」著者。一緒にアプリを作って成功させましょう！';
}

// Path: people.peoples.masaki
class _StringsPeoplePeoplesMasakiJa extends _StringsPeoplePeoplesMasakiEn {
	_StringsPeoplePeoplesMasakiJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get name => '佐藤 将来';
	@override String get nickname => 'Masaki';
	@override String get company => 'フリーランス';
	@override String get role => '個人開発プロジェクト主宰';
	@override String get description => '1995年生まれ。愛知県出身。明治大学国際日本学部卒。在学中、特定非営利活動法人アイセック・ジャパンにて海外インターンシップを経験、台湾の英語教育スタートアップにてマーケティング業務にも携わる。その後、大学時代の友人とサービス立ち上げに複数取り組むが、いずれも失敗。その間、UberEats等で生計を立てていた。現在は、フリーランスFlutterエンジニアとして活動しながら、自身のアプリを開発中。Flutterを通して、自分のアイデアを形にしていきましょう！';
}

// Path: people.peoples.uetomo
class _StringsPeoplePeoplesUetomoJa extends _StringsPeoplePeoplesUetomoEn {
	_StringsPeoplePeoplesUetomoJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get name => '上野 智弘';
	@override String get nickname => 'うえとも';
	@override String get company => 'フリーランス';
	@override String get role => 'オフ会担当';
	@override String get description => '1993年生まれ。山形県出身。学生時代は野球に打ち込み、全国軟式野球選手権大会ベスト8、国体出場。水道会社、ラーメン店副店長を経て、地元の友人がIT関連で起業したことがキッカケでプログラミングを学習する為にセブ島に留学する。現在は、Flutterエンジニアとして活動している。趣味のダンスでは、ももいろクローバーZ公式のフリコピ大会にも出場し、審査員特別賞を2回受賞する。楽しいことが大好きなので、エンジニア同士交流して横の繋がりを深めていきましょう！期待してるよ。';
}

// Path: people.peoples.tokkuu
class _StringsPeoplePeoplesTokkuuJa extends _StringsPeoplePeoplesTokkuuEn {
	_StringsPeoplePeoplesTokkuuJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get name => '徳田 真之介';
	@override String get nickname => 'tokkuu';
	@override String get company => '株式会社メルカリ';
	@override String get role => 'AWS, LINE担当';
	@override String get description => '1991年生まれ。福岡出身。九州大学理学部物理学科卒業後、都内SIerにてインフラエンジニアを5年間経験。その後ミロゴス株式会社を経て株式会社サイバーエージェントにJoin。フロントエンド、バックエンド、インフラやPMなどフルスタックにこなすエンジニアとして従事中。好きな技術はFlutter/Next.js/Node.js/AWS CDK/AWS Lambda/Firebase。大学時代にはバンドマンとしてアルバムを2作自主リリースし、ツアーを実施する傍ら、塾講師・家庭教師などを経験し、人に教えるのも大好き。';
}

// Path: people.peoples.cobo
class _StringsPeoplePeoplesCoboJa extends _StringsPeoplePeoplesCoboEn {
	_StringsPeoplePeoplesCoboJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get name => '小堀内 志';
	@override String get nickname => 'cobo';
	@override String get company => 'クラウドエース株式会社';
	@override String get role => '講師';
	@override String get description => '1998年生まれ。岩手県出身。2年制情報系専門学校を卒業後、県内のSIerに就職し、4年間電子カルテシステムの開発に携わる。その後エンジニア同士の繋がりと自身の技術領域を広げるために上京し、クラウドエース株式会社にてGoogle Cloudのスキルを習得中。趣味は弾き語りや音楽制作。kboyのYouTubeのBGMは彼が制作しています。楽しく学習できる環境作りを心がけていきます！';
}

// Path: people.peoples.gan
class _StringsPeoplePeoplesGanJa extends _StringsPeoplePeoplesGanEn {
	_StringsPeoplePeoplesGanJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get name => '岩本 崚汰';
	@override String get nickname => 'gan';
	@override String get company => 'フリーランス（NPO支援「エイドル」開発他）';
	@override String get role => '講師';
	@override String get description => '2000年生まれ。埼玉県出身。新潟大学理学部理学科数学プログラム卒。現在は同大学大学院の修士課程2年で応用数学の理論（凸解析学における漸近挙動）を研究中。また、2021年4月よりフリーランスとしてFlutter製のNPO支援アプリ「エイドル」の開発に参画している。Flutter大学では2023年2月に新潟オフ会を主催。趣味はバドミントン。質問者に寄り添ったコミュニケーションができるよう頑張っていきます！';
}

// Path: people.peoples.ota
class _StringsPeoplePeoplesOtaJa extends _StringsPeoplePeoplesOtaEn {
	_StringsPeoplePeoplesOtaJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get name => '太田 龍之介';
	@override String get nickname => 'ryu';
	@override String get company => '株式会社VISIONARY JAPAN';
	@override String get role => '講師';
	@override String get description => '1991年、静岡県生まれ。独学で異業種からスタートアップの会社に転職。FlutterエンジニアとしてFlutter webとFirebaseを用いたtoB向けのカスタマーサクセス専門サービスの開発に従事。現在は、株式会社VISIONARY JAPANで様々な案件に参画。個人開発の成果として、うさぎの体調管理用アプリ「うさぎDiary」をリリース。「うさぎの気持ち」という雑誌に掲載される。初学者に寄り添って開発のサポートができるように頑張ります！';
}

// Path: people.peoples.heyhey
class _StringsPeoplePeoplesHeyheyJa extends _StringsPeoplePeoplesHeyheyEn {
	_StringsPeoplePeoplesHeyheyJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get name => '小川 将平';
	@override String get nickname => 'heyhey';
	@override String get company => '株式会社マネーフォワード';
	@override String get role => '記事や登壇でコミュニティをリード';
	@override String get description => '1984年生まれ。石川県金沢に生まれ、その後高校まで海外を転々とする。上智大学比較文化学科卒。10年近く商社、メーカーの営業を経験後、エンジニアに転身。４年間フードテック系スタートアップでモバイルエンジニアとして従事した後、2023年 5月より株式会社マネーフォワードにてFlutterエンジニアとして勤務。英語とFlutterだけが強みの遅咲きエンジニア。使ってきた技術はFlutter/Dart/Firebase/Node.js/Typescript。最近ではAIやWeb３関連の技術にハマってます。';
}

// Path: people.peoples.minn
class _StringsPeoplePeoplesMinnJa extends _StringsPeoplePeoplesMinnEn {
	_StringsPeoplePeoplesMinnJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get name => '北山 史織';
	@override String get nickname => 'minn';
	@override String get company => '株式会社プラゴ';
	@override String get role => '講師';
	@override String get description => '2001年生まれ。青森県出身。高校卒業後上京し、Sler企業に一般事務として勤務。会社の同僚から勧められたのがきっかけでプログラミングを学習し、個人開発で画像のコレクションアプリをリリース。2022年7月に未経験からFlutterエンジニアへ転身し、AxiaWorksLLCで様々な案件に参画。現在は株式会社プラゴにてエンジニアを行う。仕事のできるカッコいい女性エンジニアを目指して日々努力しています。楽しく学んで一緒に成長していきましょう！';
}

// Path: people.peoples.odaken
class _StringsPeoplePeoplesOdakenJa extends _StringsPeoplePeoplesOdakenEn {
	_StringsPeoplePeoplesOdakenJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get name => '小田剣';
	@override String get nickname => 'おだけん';
	@override String get company => 'フリーランス（NPO支援「エイドル」開発他）';
	@override String get role => '講師';
	@override String get description => '1998年生まれ。佐賀県出身。専修大学経営学部経営学科卒。小学生から大学生までラグビーに打ち込み、全国国体４位を経験。大学卒業後は、ネットワークエンジニアとして就職、3社経験をした後、現在はFlutterエンジニアとして活動している。Flutter製のNPO支援アプリ「エイドル」の開発に参画し、テックフォードアカデミーにて講師を担当している。アプリ開発の楽しさをお伝えできるようサポート頑張ります！';
}

// Path: people.peoples.miyajic
class _StringsPeoplePeoplesMiyajicJa extends _StringsPeoplePeoplesMiyajicEn {
	_StringsPeoplePeoplesMiyajicJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get name => '宮路 洸';
	@override String get nickname => 'みやジック';
	@override String get company => '株式会社SODA';
	@override String get role => '講師';
	@override String get description => '1997年生まれ、愛知県出身。\n北海道大学情報科学院を卒業後、チームラボ株式会社に新卒で入社しスマホアプリエンジニアとして勤務中。学生時代からFlutter大学に参加し、共同開発ではスキ街を発案し継続中に開発中！\n楽しく開発や勉強のサポートをしていきたいと思います！';
}

// Path: people.peoples.aoi
class _StringsPeoplePeoplesAoiJa extends _StringsPeoplePeoplesAoiEn {
	_StringsPeoplePeoplesAoiJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get name => '東 優太';
	@override String get nickname => 'Aoi Umigishi';
	@override String get company => 'フリーランス';
	@override String get role => '講師';
	@override String get description => '1992年生まれ。千葉出身。早稲田大学大学院基幹理工学研究科数学応用数理専攻卒。卒業後、トランス・コスモス株式会社に入社し、3次元CADを用いた機械部品設計エンジニアとして従事。「世界中の誰かが、自分の作ったアプリで笑顔になってほしい」という思いから、退職後、個人アプリ開発を開始し、半年で5つのFlutterアプリをリリース、フリーランスエンジニアとなる。Flutter大学のオウンドメディア「週刊Flutter大学」の運営、記事執筆も担当。「自走できるエンジニア化」を手助けします！';
}

// Path: people.peoples.naoki
class _StringsPeoplePeoplesNaokiJa extends _StringsPeoplePeoplesNaokiEn {
	_StringsPeoplePeoplesNaokiJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get name => '若田 直希';
	@override String get nickname => 'わかなお';
	@override String get company => '株式会社Retty';
	@override String get role => '個人開発者の星';
	@override String get description => '1998年生まれ。北海道出身。北海道大学農学院卒。好きな食べ物バナナ。\n在学中にFlutter大学に入会しプログラミング学習を開始。卒業後、株式会社Rettyに入社しモバイルアプリチームでAndroidエンジニアとして日々奮闘中。個人開発ではFlutterで二郎系ラーメンに関するアプリを運用中で1日のユーザー数100人を達成。';
}

// Path: people.peoples.kenty
class _StringsPeoplePeoplesKentyJa extends _StringsPeoplePeoplesKentyEn {
	_StringsPeoplePeoplesKentyJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get name => '戸倉 健';
	@override String get nickname => 'kenty';
	@override String get company => 'フリーランス';
	@override String get role => '講師';
	@override String get description => '1997年生まれ、埼玉県出身。千葉工業大学未来ロボティクス学科を卒業後、ダイアモンドヘッド株式会社に入社し、アパレル業界向けのECサービス開発に3年従事。2024年からフリーランスに転身し、Webサイト制作、Flutterアプリ(iOS, Android, Linux) 、講師業務など幅広い分野で活動中。2024年3月に株式会社ワンアーカーのテックリードに就任。実は個人でリリースしたアプリがないので、皆さんと一緒に学びながら開発したいと思ってます！乞うご期待！';
}

// Path: people.peoples.fen
class _StringsPeoplePeoplesFenJa extends _StringsPeoplePeoplesFenEn {
	_StringsPeoplePeoplesFenJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get name => '上田 賢志';
	@override String get nickname => 'fen';
	@override String get company => 'フリーランス';
	@override String get role => '講師';
	@override String get description => '2003年生まれ。福岡県出身。2022年にFlutter大学に参加し、Flutterシェアハウスや Flutter別荘で Flutter を学びフリーランスとして活動中。未経験から Flutter に触れ始め、躓いたところや苦しんだところなどたくさんの経験があるので、知見の共有や技術的なサポートをしてきたいと思います！個人開発ではネイティブ特有の機能を Flutter で利用できるような実装をやってます。趣味は麻雀と将棋です！';
}

// Path: join.joinSteps.step01
class _StringsJoinJoinStepsStep01Ja extends _StringsJoinJoinStepsStep01En {
	_StringsJoinJoinStepsStep01Ja._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'GitHub認証';
}

// Path: join.joinSteps.step02
class _StringsJoinJoinStepsStep02Ja extends _StringsJoinJoinStepsStep02En {
	_StringsJoinJoinStepsStep02Ja._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'プランを選択して決済';
}

// Path: join.joinSteps.step03
class _StringsJoinJoinStepsStep03Ja extends _StringsJoinJoinStepsStep03En {
	_StringsJoinJoinStepsStep03Ja._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'Slackにて1on1のご案内';
	@override String get titleMobile => 'Slackにて\n1on1のご案内';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'why.why_flutter': return 'Why Flutter?';
			case 'why.description': return 'Flutter is rapidly gaining popularity with incredible momentum. The enthusiasm of its developer community, backed by Google, along with its high productivity and excellent developer UX, have led to its quick adoption in the business world. Flutter Daigaku resonated with the appeal of Flutter and has been supporting the Japanese Flutter community since April 2020. Moving forward, we aim to include the global community, creating a world where developers can enjoy learning, exchanging work, and sharing app development knowledge.';
			case 'why.learn_more': return 'Learn more about Flutter';
			case 'works.member_development_record': return 'Members\' Developments';
			case 'works.released_ago': return 'Released';
			case 'works.updated_ago': return 'Updated';
			case 'works.joint_development': return 'Joint Development';
			case 'works.individual_development': return 'Individual Development';
			case 'about.three_features': return '3 features of Flutter Daigaku';
			case 'about.youtube_free': return 'Flutter lecture YouTube is available for free';
			case 'about.live_support': return 'Live instructor support';
			case 'about.ai_training': return 'Ask both AI and human instructors at the same time';
			case 'about.coach': return 'We will be your learning coach.';
			case 'about.learn_from_code': return 'Learn from reading the code';
			case 'about.flutter_textbook': return 'Learn from the Flutter textbook';
			case 'about.joint_study_meeting': return 'Joint study meetings for output';
			case 'about.individual_development_presentation': return 'Boost motivation with individual development presentations';
			case 'about.team_development': return 'Develop as a team';
			case 'about.engineer_introduction': return 'We also introduce engineers';
			case 'about.slack_interaction': return 'Way too active Slack communications';
			case 'about.online_workroom': return 'Concentrate in an online workspace';
			case 'about.online_exchange_meeting': return 'Make friends at online exchange meetups';
			case 'about.share_house_off_meeting': return 'Share houses and in-person meetups';
			case 'about.job_is_here': return 'Your job is here';
			case 'about.youtube_free_description': return 'YouTube channel \'Flutter Daigaku\' offers free learning materials. Please check it out.';
			case 'about.live_support_description': return 'For those in the Flutter training plan, active Flutter engineers provide live support. You can also post questions on GitHub issues if you need text-based help.';
			case 'about.ai_training_description': return 'With the AI Training Plan, you can ask unlimited questions to Gemini 2.5 Pro, the latest AI model. Get instant answers 24/7 and accelerate your Flutter learning with human instructor support when needed.';
			case 'about.learn_from_code_description': return 'You can view the raw code of the Flutter Daigaku app and apps developed collaboratively on Github. Please check out our free public repositories.';
			case 'about.flutter_textbook_description': return 'If you\'re on the Task Learning Plan or higher, you can learn with the Flutter Daigaku\'s exclusive textbook (generally priced at 5,000 yen on Zenn) and receive reviews when you complete tasks.';
			case 'about.joint_study_meeting_description': return 'We hold collaborative study meetings on Wednesdays at 9 PM.';
			case 'about.individual_development_presentation_description': return 'Monthly presentations are held to showcase individual development achievements.';
			case 'about.team_development_description': return 'Teams are formed every three months for collaborative development!';
			case 'about.engineer_introduction_description1': return 'At Flutter Daigaku, we accept inquiries from those looking for Flutter engineers. We can introduce you to suitable engineers from the ';
			case 'about.engineer_introduction_description2': return ' engineers participating in Flutter Daigaku.';
			case 'about.slack_interaction_description': return 'Conversations are not only about exchanging information on Flutter, but also about various topics from the latest AI trends and unique career discussions for engineers to talks about expanding overseas. Just one day without checking Slack results in a huge backlog of unread messages.';
			case 'about.online_workroom_description': return 'We have prepared an online workspace using Gather.';
			case 'about.online_exchange_meeting_description': return 'We hold online exchange meetups once a month using Zoom.';
			case 'about.share_house_off_meeting_description': return 'We have a share house called \'FlaHa\'(short sound of Flutter-House) in Ebisu, Tokyo, and an old house called \'Flutter Besso\' in Higashiomi, Shiga, where Flutter Daigaku members live. In addition, in-person meetups are held every two months in Tokyo, Sapporo, Nagoya, Osaka, Fukuoka, etc.';
			case 'about.job_is_here_description': return 'Flutter Daigaku is a community where you can learn Flutter and find a job. We share Flutter jobs, and we also introduce engineers to companies looking for Flutter engineers.';
			case 'about.youtube_free_button': return 'YouTube \'Flutter Daigaku\'';
			case 'about.ai_training_button': return 'What is AI Training Plan?';
			case 'about.learn_from_code_button': return 'GitHub \'Flutter Daigaku\'';
			case 'about.flutter_textbook_button': return 'Zenn Book \'Flutter Textbook\'';
			case 'about.joint_study_meeting_button': return 'Summary of Joint Study Meetings';
			case 'about.individual_development_presentation_button': return 'What is Individual Development Presentation?';
			case 'about.team_development_button': return 'What is Team Development?';
			case 'about.engineer_introduction_button': return 'Looking for Flutter Engineers?';
			case 'about.slack_interaction_button': return 'How to Use Flutter Daigaku on Slack';
			case 'about.online_workroom_button': return 'What is Online Workspace?';
			case 'about.online_exchange_meeting_button': return 'What is Online Exchange Meetup?';
			case 'about.share_house_off_meeting_button': return 'Flutter Besso\'s Twitter';
			case 'about.mentor_plans': return 'Exclusive mentoring platform within Flutter Daigaku';
			case 'about.mentor_plans_description': return 'There exists a platform where you can receive one-on-one instruction from a teacher within Flutter Daigaku, started under the alias \'CodeBoy2\'. Teachers are Flutter Daigaku members and can provide instruction and mentoring through a learning platform that only takes an extraordinary fee of 4-10%. Learners can receive one-on-one instruction from excellent engineers within Flutter Daigaku.';
			case 'plan.community': return 'Community Plan';
			case 'plan.learning': return 'Learning Plan';
			case 'plan.trainingLight': return 'Light Training Plan';
			case 'plan.training': return 'Training Plan';
			case 'plan.aiTraining': return 'AI Training Plan';
			case 'price.lPDescription.community': return 'Study together in a community';
			case 'price.lPDescription.learning': return 'Learn Flutter with exclusive materials';
			case 'price.lPDescription.trainingLight': return 'Learn Flutter with professional help sometimes';
			case 'price.lPDescription.training': return 'Master Flutter with professional help';
			case 'price.lPDescription.aiTraining': return 'Learn Flutter with unlimited AI';
			case 'price.lPFeature1': return '・Access to the app\n・Join the Slack\n・Browse the GitHub\n・Collaborate on dev projects\n・Group study\n・Access videos\n・Networking events';
			case 'price.lPFeature2': return 'Everything in Community, and\n・Access to exclusive materials';
			case 'price.lPFeature3': return 'Everything in Learning, and\n・Light support included';
			case 'price.lPFeature4': return 'Everything in Learning, and\n・Full support included\n・Text questions on github\n・Give away 2,860JPY Flutter Book';
			case 'price.lPFeature5': return 'Everything in Learning, and\n・Unlimited Gemini 2.5 Pro chat \n・10y experienced Human instructor support when needed\n・Give away 2,860JPY Flutter Book';
			case 'price.yen': return 'JPY';
			case 'price.yen_per_month': return ' JPY / mo';
			case 'price.month': return 'mo';
			case 'price.threeMonth': return '3mo';
			case 'price.sixMonth': return '6mo';
			case 'price.year': return 'yr';
			case 'price.if_convert_to_month': return 'Equivalent to';
			case 'price.threeMonthsOff': return '3 months off!!';
			case 'interval.monthly': return 'Monthly';
			case 'interval.threeMonth': return '3Month';
			case 'interval.sixMonth': return '6Month';
			case 'interval.annual': return 'Annual';
			case 'cta_github': return 'Sign up with GitHub';
			case 'cta': return 'Sign up with Email';
			case 'cta_available_count1': return 'Only ';
			case 'cta_available_count2': return ' more available now.';
			case 'cta_no_available': return 'No more available right now.';
			case 'people.subtitle1': return 'Instructors';
			case 'people.subtitle2': return 'Powerful members';
			case 'people.other1': return 'The total is';
			case 'people.other2': return 'members!';
			case 'people.slackAPI': return '※Counted every hour using Slack API.';
			case 'people.peoples.kosuke.name': return 'Kosuke Saigusa';
			case 'people.peoples.kosuke.nickname': return 'Kosuke';
			case 'people.peoples.kosuke.company': return 'Ubie, Inc.';
			case 'people.peoples.kosuke.role': return 'Study Meetup Leader';
			case 'people.peoples.kosuke.description': return 'Born in 1995, from Fukuoka Prefecture. Graduated from Kyushu University with a degree in Mechanical and Aerospace Engineering. After graduation, worked at Siemens’ research facility in Belgium, focusing on machine learning. Later became a Web and Flutter engineer, working at Atama Plus Co., Ltd., SODA Inc., and currently employed at Omiai Co., Ltd. Spoke at FlutterKaigi 2023 and FlutterNinjas 2024. Developer of multiple pub packages. Let’s enjoy learning technology together!';
			case 'people.peoples.daigo.name': return 'Daigo Wakabayashi';
			case 'people.peoples.daigo.nickname': return 'Daigo';
			case 'people.peoples.daigo.company': return 'Freelance';
			case 'people.peoples.daigo.role': return 'Online Meetup Leader';
			case 'people.peoples.daigo.description': return 'Born in 1998 in Osaka. After graduating from Osaka University of Health and Sport Sciences, he joined UNIQLO. In October 2020, he resigned from UNIQLO to become a disciple of KBOY and moved from Osaka to Sapporo to assist in the development of Flutter-based apps. After a one-year training period, he has been working as a freelance Flutter engineer since October 2021 and has participated in several app development projects, including idol-related projects. He is active in various fields at Flutter Daigaku, such as organizing online social gatherings and managing Flutter Gakkai. He is known for his easy-to-understand advice and article writing as a presence close to beginners in teaching. Let\'s work hard together, beginners!';
			case 'people.peoples.kboy.name': return 'Kei Fujikawa';
			case 'people.peoples.kboy.nickname': return 'kboy';
			case 'people.peoples.kboy.company': return 'KBOY Inc. CEO';
			case 'people.peoples.kboy.role': return 'Founder';
			case 'people.peoples.kboy.description': return 'Born in 1991, from Sapporo. Graduated from Waseda University\'s School of Creative Science and Engineering, Department of Mechanical Engineering. After experiencing the role of development director for a flea market app at Proto Corporation, he transitioned to engineering and worked on \'NewsDigest\' at JX Press Corp and the AR app \'Pechabato\' at Graffity. After a year and a half as a freelancer, he founded KBOY Inc. in June 2020. Achieving 20,000 subscribers on YouTube and TikTok, which he had been doing since his freelance days, he started the Flutter Daigaku service with great enthusiasm. Let\'s work together to create successful apps!';
			case 'people.peoples.masaki.name': return 'Masaki Satoh';
			case 'people.peoples.masaki.nickname': return 'Masaki';
			case 'people.peoples.masaki.company': return 'Freelance';
			case 'people.peoples.masaki.role': return 'Personal Development Project Leader';
			case 'people.peoples.masaki.description': return 'Born in 1995 in Aichi Prefecture. Graduated from the International Japanese Studies Department at Meiji University. During his studies, he experienced an overseas internship at AIESEC Japan, where he also worked on marketing for an English education startup in Taiwan. After that, he worked on several service start-ups with his university friends, but they all failed. In the meantime, he made a living by working for Uber Eats, among others. Currently, he is a freelance Flutter engineer and is developing his own app. Let\'s use Flutter to bring your ideas to life together!';
			case 'people.peoples.uetomo.name': return 'Tomohiro Ueno';
			case 'people.peoples.uetomo.nickname': return 'Uetomo';
			case 'people.peoples.uetomo.company': return 'Freelance';
			case 'people.peoples.uetomo.role': return 'Event Coordinator';
			case 'people.peoples.uetomo.description': return 'Born in 1993 in Yamagata Prefecture. He devoted himself to baseball during his student years and achieved Best 8 in the National Softball Baseball Championship and participated in the National Sports Festival. After working at a water supply company and serving as the deputy manager of a ramen shop, he decided to learn programming because a friend from his hometown started a business related to IT. He studied abroad on Cebu Island to learn programming. Currently, he is working as a Flutter engineer. He loves fun things, so let\'s deepen our connections as engineers and have fun together!';
			case 'people.peoples.tokkuu.name': return 'Shinnosuke Tokuda';
			case 'people.peoples.tokkuu.nickname': return 'tokkuu';
			case 'people.peoples.tokkuu.company': return 'Mercari, Inc.';
			case 'people.peoples.tokkuu.role': return 'AWS and LINE Specialist';
			case 'people.peoples.tokkuu.description': return 'Born in 1991, from Fukuoka. After graduating from Kyushu University\'s Faculty of Science, Department of Physics, he worked as an infrastructure engineer at a Tokyo-based SIer (System Integrator) for 5 years. He then joined Milogos Inc., after that, he joined CyberAgent, Inc. where he is currently engaged as a full-stack engineer, handling frontend, backend, infrastructure, and project management. His favorite technologies are Flutter, Next.js, Node.js, AWS CDK, AWS Lambda, and Firebase. During his university days, he independently released two albums as a band member, conducted tours, and also gained experience as a cram school tutor and private tutor, which fostered his love for teaching.';
			case 'people.peoples.cobo.name': return 'Nozomi Kobayashi';
			case 'people.peoples.cobo.nickname': return 'cobo';
			case 'people.peoples.cobo.company': return 'Cloud Ace';
			case 'people.peoples.cobo.role': return 'Instructor';
			case 'people.peoples.cobo.description': return 'Born in 1998, hailing from Iwate Prefecture. After graduating from a two-year Information Technology College, he joined an SIer (System Integrator) in the same prefecture and was involved in the development of electronic medical record systems for four years. He then moved to Tokyo to expand his network among engineers and broaden his technical expertise, and is currently learning Google Cloud skills at Cloud Ace Inc. His hobbies include playing guitar, singing, and music production. He produces the background music for kboy\'s YouTube videos. He strives to create an enjoyable learning environment!';
			case 'people.peoples.gan.name': return 'Ryota Iwamoto';
			case 'people.peoples.gan.nickname': return 'gan';
			case 'people.peoples.gan.company': return 'Freelance';
			case 'people.peoples.gan.role': return 'Instructor';
			case 'people.peoples.gan.description': return 'Born in 2000, from Saitama Prefecture. Graduated from the Mathematics Program of the Faculty of Science at Niigata University. Currently in the second year of the Master\'s program at the same university, researching the theory of applied mathematics (asymptotic behavior in convex analysis). Since April 2021, working as a freelancer on the development of the Flutter-made NPO support application, \'Aidl\'. Hosted the Niigata off-meetup in February 2023 at Flutter Daigaku. My hobby is badminton. I will do my best to communicate closely with learners!';
			case 'people.peoples.ota.name': return 'Ota Ryunosuke';
			case 'people.peoples.ota.nickname': return 'ryu';
			case 'people.peoples.ota.company': return 'VISIONARY JAPAN';
			case 'people.peoples.ota.role': return 'Instructor';
			case 'people.peoples.ota.description': return 'Born in Shizuoka Prefecture in 1991. I transitioned from a completely different industry to a startup company through self-study. I work as a Flutter engineer, engaged in the development of a B2B-oriented customer success specialist service using Flutter web and Firebase. Currently, I am involved in various projects at VISIONARY JAPAN Inc. As a result of my personal development, I released a health management application for rabbits, \'Rabbit Diary\'. It was featured in a magazine called \'The Feelings of Rabbits\'. I will do my best to provide development support that caters to beginners!';
			case 'people.peoples.heyhey.name': return 'Shohei Ogawa';
			case 'people.peoples.heyhey.nickname': return 'heyhey';
			case 'people.peoples.heyhey.company': return 'Money Forward';
			case 'people.peoples.heyhey.role': return 'Leading the community';
			case 'people.peoples.heyhey.description': return 'Born in Kanazawa, 1984. Lived around the world until coming back to Japan for high school. Graduated Sophia University, Department of Comparative Culture. Made a transition to Software Developer, after 10 years of experience as a Sales in Food industry. After working 4 years as a Mobile application developer at Food tech Startup, joined MoneyForward inc. in May, 2023. Late bloomer whose only strength is in English and Flutter. Have used Flutter/Dart/Firebase/Node.js/Typescript. Into technologies related to AI and Web3 these days.';
			case 'people.peoples.minn.name': return 'Shiori Kitayama';
			case 'people.peoples.minn.nickname': return 'minn';
			case 'people.peoples.minn.company': return 'PLUGO';
			case 'people.peoples.minn.role': return 'Instructor';
			case 'people.peoples.minn.description': return 'Born in 2001, hailing from Aomori Prefecture. After graduating high school, I moved to Tokyo and started working as a general administrative staff at Sler Corporation. It was a colleague\'s recommendation that sparked my interest in programming, leading me to develop and release a personal project - an image collection app. In July 2022, I made a career change from being inexperienced to becoming a Flutter engineer. And then, I\'m actively involved in various projects at AxiaWorksLLC. After that, I ended up working at PLUGO. My daily motivation is to strive to become a competent, stylish female engineer. Let\'s enjoy learning and grow together!';
			case 'people.peoples.odaken.name': return 'Tsurugi Oda';
			case 'people.peoples.odaken.nickname': return 'odaken';
			case 'people.peoples.odaken.company': return 'Freelance';
			case 'people.peoples.odaken.role': return 'Instructor';
			case 'people.peoples.odaken.description': return 'Born in 1998. Originally from Saga Prefecture. Graduated from Senshu University\'s Faculty of Business Administration, Department of Business Administration. From elementary school to university, he was dedicated to rugby and achieved a 4th place finish at the national athletic meet. After graduating from university, he started his career as a network engineer and, after experiencing three different companies, he is now active as a Flutter engineer. He has been involved in the development of a Flutter-based NPO support app called "Aidol" and is serving as an instructor at Techford Academy. He strives to convey the joy of app development!';
			case 'people.peoples.miyajic.name': return 'Kou Miyaji';
			case 'people.peoples.miyajic.nickname': return 'miyajic';
			case 'people.peoples.miyajic.company': return 'SODA inc.';
			case 'people.peoples.miyajic.role': return 'Instructor';
			case 'people.peoples.miyajic.description': return 'Born in 1997 in Aichi Prefecture, I graduated from the Graduate School of Information Science and Technology at Hokkaido University. Currently, I am working as a smartphone app engineer at TeamLab Inc., having joined the company as a new graduate. Since my student days, I have been involved with Flutter University, where I came up with the idea for "Suki Machi" and am continuing its development. I am excited to support fun learning and development experiences for others!';
			case 'people.peoples.aoi.name': return 'Yuta Azuma';
			case 'people.peoples.aoi.nickname': return 'Aoi Umigishi';
			case 'people.peoples.aoi.company': return 'Freelance';
			case 'people.peoples.aoi.role': return 'Instructor';
			case 'people.peoples.aoi.description': return 'Born in 1992 in Chiba. After graduating from the Graduate School of Fundamental Science and Engineering at Waseda University, he joined Trans Cosmos Co., Ltd. and worked as a mechanical parts design engineer using 3D CAD. He left the company because he wanted someone, somewhere in the world to smile because of the app he created. After half a year of developing individual apps, he became a freelance engineer by releasing five Flutter apps. He also manages and writes articles for the Flutter Daigaku\'s own media, "Weekly Flutter Daigaku." Let us assist you in becoming a "self-driving" engineer!';
			case 'people.peoples.naoki.name': return 'Naoki Wakata';
			case 'people.peoples.naoki.nickname': return 'Wakanao';
			case 'people.peoples.naoki.company': return 'Retty Inc.';
			case 'people.peoples.naoki.role': return 'A star among indie developers';
			case 'people.peoples.naoki.description': return 'Born in 1998. Hailing from Hokkaido. Graduate of the Faculty of Agriculture at Hokkaido University. Favorite food: bananas.\nJoined Flutter Daigaku during university and started learning programming. After graduation, joined the company Retty and is currently striving as an Android engineer in the mobile app team. In personal development, operates an app related to Jiro-style ramen using Flutter, achieving a daily user count of 100.\nLet\'s learn app development together with joy!!';
			case 'people.peoples.kenty.name': return 'Ken Tokura';
			case 'people.peoples.kenty.nickname': return 'kenty';
			case 'people.peoples.kenty.company': return 'Freelance';
			case 'people.peoples.kenty.role': return 'Instructor';
			case 'people.peoples.kenty.description': return 'Born in 1997 in Saitama Prefecture. Graduated from the Future Robotics Department at Chiba Institute of Technology. After graduation, worked at Diamondhead Inc. for 3 years, engaged in the development of EC services for the apparel industry.\nSince 2024, transitioned to freelancing, active in various fields such as website development, Flutter apps (iOS, Android, Linux), and teaching.\nIn March 2024, appointed as the tech lead at One Archer Co., Ltd.\nActually, I haven\'t released any apps personally, so I\'m eager to learn and develop together with everyone! Stay tuned!';
			case 'people.peoples.fen.name': return 'Kenshi Ueda';
			case 'people.peoples.fen.nickname': return 'fen';
			case 'people.peoples.fen.company': return 'Freelance';
			case 'people.peoples.fen.role': return 'Instructor';
			case 'people.peoples.fen.description': return 'Born in 2003, from Fukuoka Prefecture. Joined Flutter University in 2022, learning Flutter at places like the Flutter share house and Flutter villa, and now working as a freelancer. Started Flutter with no prior experience and faced many challenges along the way, which makes me eager to share knowledge and provide technical support! In my personal projects, I implement native-specific features using Flutter. My hobbies are Mahjong and Shogi!';
			case 'voice.description': return 'Here are some blogs\nabout Flutter Daigaku in Japanese';
			case 'projects.subtitle': return 'Cool things members are doing';
			case 'projects.flutter_house.title': return 'Flutter House';
			case 'projects.flutter_house.description': return 'Flutter House is a sharehouse for Flutter engineers founded by Konbu-san. Located in Ebisu, Tokyo, it\'s a 4-6 person apartment where engineers live and enjoy work and play to the fullest. A drinking party called UTAGE is held once a month. It\'s a base in Tokyo where Flutter Daigaku members can easily drop in.';
			case 'projects.flutter_house.dateDescription': return 'October 2020~';
			case 'projects.flutter_gakkai.title': return 'Flutter Gakkai';
			case 'projects.flutter_gakkai.description': return 'Flutter Gakkai is a study group for Flutter engineers. It\'s an online study group that aims to boost the Flutter community in Japan beyond Flutter Daigaku. It has been held online twice so far, with the aim of holding a large-scale offline event in the future.';
			case 'projects.flutter_gakkai.dateDescription': return 'January 2022~';
			case 'projects.weekly_flutter_university.title': return 'Weekly Flutter Daigaku';
			case 'projects.weekly_flutter_university.description': return 'Weekly Flutter Daigaku is a WEB media started by Aoi-san as editor-in-chief. The \'This Week\'s Flutter News\' updated every week allows you to catch up with the latest Flutter information. In addition, at the time of the latest release of Flutter official, it releases a Japanese summary article at the fastest speed and leads the Japanese Flutter media.';
			case 'projects.weekly_flutter_university.dateDescription': return 'March 2022~';
			case 'projects.hackathon_victory.title': return 'Hackathon victory';
			case 'projects.hackathon_victory.description': return 'Flutter lovers participated in the hackathon as a team within Flutter Daigaku. In the first round of Spajam2022, FlutterLovers won the grand prize. The Flutter x Firebase skill set is fast and suitable for hackathons. There are plans for other team participation in the future, so expectations are high.';
			case 'projects.hackathon_victory.dateDescription': return 'August 2022';
			case 'projects.flutter_villa.title': return 'Flutter Besso';
			case 'projects.flutter_villa.description': return 'Flutter Besso started when Konbu-san purchased an old Japanese house in Higashiomi City, Shiga Prefecture. It is the second sharehouse after Flutter House and is also expected to be a base for Flutter camps in the future. There is a handmade sauna house in the garden, a gym with a power rack in the garage, and high-speed wifi is also available. You can stay overnight by contacting us in advance.';
			case 'projects.flutter_villa.dateDescription': return 'August 2022~';
			case 'projects.flutter_women.title': return 'Flutter Womens';
			case 'projects.flutter_women.description': return 'Female members of Flutter Daigaku regularly gather for girls\' meetings and app development. Currently, the Flutter Women team is jointly developing an app for Christmas!';
			case 'projects.flutter_women.dateDescription': return 'October 2022~';
			case 'projects.xx_dart.title': return '〇〇.dart';
			case 'projects.xx_dart.description': return 'Under the concept of "locality × Flutter," we hold a Flutter study group called "〇〇.dart." Anyone interested in Flutter is welcome to participate, not just those enrolled in Flutter Daigaku. In May, there are plans to hold Osaka.dart, and Tokyo.dart in June.. Additionally, we plan to hold Hokkaido.dart during the beer garden season in August.';
			case 'projects.xx_dart.dateDescription': return 'March 2023~';
			case 'projects.morning_mokumoku.title': return 'Morning Mokumoku';
			case 'projects.morning_mokumoku.description': return 'The gathering place is a virtual workspace called Gather. Every morning from 7:10 to 8:00, we work together on Gather tables and then gather at the lower left table at 8:00 to report on what we accomplished that day. This habit helps us develop a routine of waking up early and working together.';
			case 'projects.morning_mokumoku.dateDescription': return 'April 2023~';
			case 'projects.tokyo_flutter_hackathon.title': return 'Tokyo Flutter Hackathon';
			case 'projects.tokyo_flutter_hackathon.description': return 'Flutter Daigaku and Yumemi jointly held the Tokyo Flutter Hackathon for two days on September 30th and October 1st. We had many companies sponsor the event, and rent the CyberAgent venue to hold the event. There were over 100 participants and 23 participating teams.';
			case 'projects.tokyo_flutter_hackathon.dateDescription': return 'September 2023';
			case 'projects.terakoya.title': return 'Terakoya Tech';
			case 'projects.terakoya.description': return 'Terakoya Tech is an engineering training program where you can learn highly demanded tools and languages as future engineering skills within six months. It\'s a selective program, completely free, and was conducted in collaboration with Ritsuan STC, Cloudtech, and Flutter University.';
			case 'projects.terakoya.dateDescription': return 'December 2023 to May 2024';
			case 'projects.flutter_book.title': return 'Flutter Tutorial Book on sale';
			case 'projects.flutter_book.description': return 'Flutter Daigaku founder kboy has published an introductory book on Flutter from Gijutsu Hyoronsha.';
			case 'projects.flutter_book.dateDescription': return 'December 2023';
			case 'projects.global_gamers_challenge.title': return 'Best Integration in Japanese - 1st place at Global Gamers Challenge';
			case 'projects.global_gamers_challenge.description': return 'Flutter Daigaku members participated in the Global Gamers Challenge, a hackathon for game development. The team\'s app called Turtle escape won the Google Wallet - Best Integration in Japanese - 1st place. They got 7500USD.';
			case 'projects.global_gamers_challenge.dateDescription': return 'May 2024';
			case 'projects.flutter_ninjas.title': return 'FlutterNinjas Tokyo 2024';
			case 'projects.flutter_ninjas.description': return 'An international Flutter conference in Tokyo Japan on Jun 13-14th 2024. See you in 2025.';
			case 'projects.flutter_ninjas.dateDescription': return 'June 2024';
			case 'media.subtitle': return 'Featured in Japanese media.';
			case 'join.subtitle': return 'Joining process';
			case 'join.joinSteps.step01.title': return 'Sign up with GitHub';
			case 'join.joinSteps.step02.title': return 'Select plan\n& make payment';
			case 'join.joinSteps.step03.title': return '1on1 zoom meeting on Slack';
			case 'join.joinSteps.step03.titleMobile': return '1on1 zoom meeting \non Slack';
			case 'qa.subtitle': return 'Frequently Asked Questions';
			case 'qa.qaList.0.q': return 'I am a beginner, is it okay to join Flutter Daigaku?';
			case 'qa.qaList.0.a': return 'Yes, it is. At Flutter Daigaku, we offer support for beginners to intermediate level learners.';
			case 'qa.qaList.1.q': return 'Should beginners start with HTML and other technologies?';
			case 'qa.qaList.1.a': return 'No, they should start with Flutter. While it\'s always helpful to have prior knowledge, many individuals who started with Flutter are now active contributors to the field.';
			case 'qa.qaList.2.q': return 'Is it okay to use Windows?';
			case 'qa.qaList.2.a': return 'Yes, it is. However, please note that you cannot debug iPhone apps on Windows, so a Mac is recommended for that purpose.';
			case 'qa.qaList.3.q': return 'What sets you apart from your competitors?';
			case 'qa.qaList.3.a': return 'We are confident in the quality of our members. Flutter Daigaku has been evolving with our members since its launch in April 2020.';
			case 'qa.qaList.4.q': return 'Is there a point for active engineers to join?';
			case 'qa.qaList.4.a': return 'Actually the 70% of members are Software engineer right now. So many join to make connections with fellow engineers. Join our community plan and create connections through study groups, joint development, online events, offline events, and other projects.';
			case 'qa.qaList.5.q': return 'Where can I contact for inquiries after joining?';
			case 'qa.qaList.5.a': return 'Please use the inquiry page on the Flutter Daigaku app.';
			case 'qa.qaList.6.q': return 'What are the payment methods?';
			case 'qa.qaList.6.a': return 'We support credit card payments (VISA, JCB, MASTER, AMEX). You will be charged on a monthly basis starting from the day you join.';
			case 'qa.qaList.7.q': return 'Can corporations also use this?';
			case 'qa.qaList.7.a': return 'There are use cases for corporations as well. For more details, please contact us through the inquiry form at the bottom right.';
			case 'qa.qaList.8.q': return 'How do I withdraw my membership?';
			case 'qa.qaList.8.a': return 'You can easily withdraw your membership through a single button on the inquiry page of the Flutter Daigaku app. No need for complicated phone inquiries.';
			case 'message.title': return 'What Makes Flutter Daigaku Community Special?';
			case 'message.message': return 'While technology continues to evolve rapidly, at Flutter Daigaku we value something beyond just technical skill acquisition - the power of a supportive learning community.\n\nWhat we treasure most is our "collaborative learning environment" where every member supports each other\'s growth and development.\n\nRather than struggling with questions and challenges alone, our experienced members generously share their knowledge, creating a welcoming space where even beginners can learn with confidence.\n\nThrough joint development projects and online study sessions, members gain practical skills that individual learning cannot provide, and most importantly, they build valuable connections with fellow developers.\n\nWould you like to join us in building a learning community that values both technical excellence and meaningful human connections?\n\nRepresentative of Flutter Daigaku,\nKei Fujikawa';
			case 'newMembers.dayAgo': return ' days ago';
			case 'newMembers.hourAgo': return ' hours ago';
			case 'newMembers.minuteAgo': return ' minutes ago';
			case 'newMembers.secondAgo': return ' seconds ago';
			case 'newMembers.future': return 'future';
			case 'newMembers.ni': return ', ';
			case 'newMembers.joined': return ' joined!';
			case 'menu.developmentExperience': return 'Works';
			case 'menu.threeFeatures': return 'Features';
			case 'menu.pricePlan': return 'Price';
			case 'menu.members': return 'Members';
			case 'menu.memberVoice': return 'Voice';
			case 'menu.enrollmentProcess': return 'Joining Process';
			case 'menu.faq': return 'FAQ';
			case 'menu.login': return 'Log In';
			case 'footer.terms': return 'Terms and Conditions';
			case 'footer.tokusho': return 'Specified Commercial Transactions Act';
			case 'footer.privacyPolicy': return 'Privacy Policy';
			case 'footer.operatingCompany': return 'Company';
			case 'underMaintenance': return 'Currently under maintenance';
			case 'schedule.title': return 'Schedule Booking';
			case 'schedule.description': return 'You can ask both AI and human instructors at the same time\nfor individual consultations and mentoring.\nPlease book your schedule from Calendly page.';
			case 'schedule.calendlyButton': return 'Book with Calendly';
			default: return null;
		}
	}
}

extension on _StringsJa {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'why.why_flutter': return 'なぜFlutterなのか？';
			case 'why.description': return 'Flutterは今すごい勢いで普及しています。開発元のGoogleや開発者コミュニティの勢い、そして少人数で高速に開発できる生産性の高さ、開発者UXの良さが評価され、ビジネスの現場でも急速に流行っています。Flutter大学はこのFlutterの魅力に共感し、2020年4月に始まり、以来日本のFlutterコミュニティを盛り上げてきました。今後は世界も視野に入れて、開発者が楽しく学習し、時に仕事を交換したり、アプリ開発の知見を共有できる世界を作っていきます。';
			case 'why.learn_more': return 'Flutterについてもっと詳しく知る';
			case 'works.member_development_record': return 'メンバーの開発実績';
			case 'works.released_ago': return 'リリース';
			case 'works.updated_ago': return '更新';
			case 'works.joint_development': return '共同開発';
			case 'works.individual_development': return '個人開発';
			case 'about.three_features': return 'Flutter大学3つの特徴';
			case 'about.youtube_free': return 'Flutter基礎講座をYouTubeで公開';
			case 'about.ai_training': return 'AIと人間講師に同時に聞ける';
			case 'about.coach': return '私たちが学習コーチをします。';
			case 'about.learn_from_code': return 'コードを読んで学べる';
			case 'about.flutter_textbook': return 'Flutterの教科書で学べる';
			case 'about.joint_study_meeting': return '共同勉強会でアウトプットできる';
			case 'about.individual_development_presentation': return '個人開発発表会でモチベを上げる';
			case 'about.team_development': return 'みんなでチーム開発ができる';
			case 'about.engineer_introduction': return 'エンジニア紹介もやってます';
			case 'about.slack_interaction': return 'Slackでの情報交換が盛ん';
			case 'about.online_workroom': return '作業部屋で集中できる';
			case 'about.online_exchange_meeting': return '交流会でエンジニア友達ができる';
			case 'about.share_house_off_meeting': return 'シェアハウス、オフ会で一生の仲間を';
			case 'about.job_is_here': return '仕事はここで見つかる';
			case 'about.youtube_free_description': return 'YouTubeチャンネル「Flutter大学」で教材を無料公開しています。Flutterの基礎が動画で学べるので、実はこれだけでアプリが作れるようになる方もいらっしゃいます。';
			case 'about.ai_training_description': return 'AI修行プランでは、最新のAIモデルGemini 2.5 Proに無制限で質問ができます。24時間いつでも即座に回答が得られ、必要に応じて経験豊富な人間講師のサポートも受けられるため、Flutter学習を爆速で進められます。';
			case 'about.learn_from_code_description': return 'Flutter大学専用アプリや共同開発で作られたアプリの生のコードをGithubで閲覧できます。providerやriverpodを使った状態管理の仕方や位置情報アプリの作り方などを実際のコードを参考にして進めることができます。このLPのFlutter Webのコードも全部見れます。';
			case 'about.flutter_textbook_description': return '月4,400円の課題学習プラン以上の方は、Flutter大学限定オリジナル教材「Flutterの教科書」や「【リリースまで学べる】位置情報APIを使ったFlutterアプリ開発」を閲覧することができます。その場合、zennで別途購入する必要はございません。教材は随時追加していきます！';
			case 'about.joint_study_meeting_description': return 'メンバーの有志で水曜日の21時から共同勉強会を行っています。メンバーが週替わりでFlutterの知見を発表したり、NotionやAIの話題など内容は多岐に渡ります。';
			case 'about.individual_development_presentation_description': return '個人開発の成果を発表する発表会が月１回行われています。自分の使ったアプリを人に知ってもらう機会にもなるし、締切効果でモチベもキープできます。みんなが何を考えて開発しているか、コードだけじゃなくマーケティングも学ぶ良い機会になります。';
			case 'about.team_development_description': return '３ヶ月ごとにチームを結成し、共同開発を行っています！3ヶ月に1回キックオフを行います。その際アイデアを持つ人がアプリのアイデアを発表し、賛同するものは参加を表明してチームを結成するというルールです。キックオフは1月、4月、7月、10月に行っています。';
			case 'about.engineer_introduction_description1': return 'Flutter大学では、Flutterエンジニアをお探しの方からのご連絡を受け付けています。Flutter大学に参加しているエンジニア';
			case 'about.engineer_introduction_description2': return '人の中から、条件に合うエンジニアをご紹介することができます。';
			case 'about.slack_interaction_description': return 'Flutterの情報交換はもちろん最新AIの動向やエンジニアならではのキャリア談義から海外進出の話まで様々な会話が行われています。１日見ないだけでSlackの未読が大量にたまります。';
			case 'about.online_workroom_description': return 'GatherやMetaLifeを用いたオンライン作業部屋を用意しています。朝のもくもく会からMTG、オンライン飲み会まで、自由に使われています。';
			case 'about.online_exchange_meeting_description': return 'zoomを用いたオンライン交流会を月に1回行っています。ここで出来たつながりで仕事の話が舞い込んだり、実は同じ出身地で盛り上がったり、素晴らしい交流の機会です。';
			case 'about.share_house_off_meeting_description': return '東京恵比寿にシェアハウス「フラハ」、滋賀県東近江市に古民家「Flutter別荘」があり、Flutter大学メンバーが住んでいます。また、オフ会は、東京、札幌、名古屋、大阪、福岡などで２ヶ月に１回ペースで行なっています。やはりオフラインでの交流は濃い話もでき、オンラインには変え難いものです。';
			case 'about.job_is_here_description': return 'FlutterWork経由での仕事はslackにてシェアされ、メンバーは応募することができます。運営によるチェックの後、条件があえば企業さんとマッチングします。お互いにコミュニケーション能力や技術力がわかっていて、信頼関係があるからこそスムーズな仕事の紹介が成り立っています。';
			case 'about.youtube_free_button': return 'YouTube「Flutter大学」';
			case 'about.ai_training_button': return 'AI修行プランとは？';
			case 'about.learn_from_code_button': return 'GitHub「Flutter大学」';
			case 'about.flutter_textbook_button': return 'zenn本「Flutterの教科書」';
			case 'about.joint_study_meeting_button': return '共同勉強会のまとめ記事';
			case 'about.individual_development_presentation_button': return '個人開発発表会とは？';
			case 'about.team_development_button': return '共同開発とは？';
			case 'about.engineer_introduction_button': return 'Flutterエンジニアをお探しの企業様はこちら';
			case 'about.slack_interaction_button': return 'Flutter大学の活用法 〜 Slack 編〜';
			case 'about.online_workroom_button': return 'オンライン作業部屋とは？';
			case 'about.online_exchange_meeting_button': return 'オンライン交流会とは？';
			case 'about.share_house_off_meeting_button': return 'Flutter別荘のTwitter';
			case 'about.mentor_plans': return 'ここだけの学習指導プラットフォーム';
			case 'about.mentor_plans_description': return '「CodeBoy2」と呼ばれる、Flutter大学内で講師にマンツーマンで指導をしてもらえるプラットフォームがあります。講師はFlutter大学メンバーで、4~10%という破格の手数料のみで、指導、メンター活動を行うことができ、学習者はFlutter大学内の優秀なエンジニアの方々の指導をマンツーマンで受けることができます。都度決済なので、どのプランの方でもお使いいただけます。マンツーマンで学習指導を受けたい方、すでに他社プラットフォームさんで学習メンターをされてる講師の方におすすめの機能です。';
			case 'plan.community': return 'コミュニティプラン';
			case 'plan.learning': return '課題学習プラン';
			case 'plan.trainingLight': return 'ライト修行プラン';
			case 'plan.training': return '修行プラン';
			case 'plan.aiTraining': return 'AI修行プラン';
			case 'price.lPDescription.community': return '全てのエンジニア向け\nコミュニティを活用しよう！';
			case 'price.lPDescription.learning': return '独学でFlutter学習する方向け\n限定教材を活用しよう！';
			case 'price.lPDescription.trainingLight': return 'ちょっと質問したい人向け\n月4回だけ質問できます！';
			case 'price.lPDescription.training': return '爆速で成長したい人向け\nたくさん質問しよう！';
			case 'price.lPDescription.aiTraining': return '爆速で成長したい人向け\nAIと人間講師に同時に聞ける！';
			case 'price.lPFeature1': return '・初回1on1MTG\n・Flutter大学Slack参加\n・GitHub Organization参加\n・共同開発への参加\n・共同勉強会の閲覧・発表\n・アーカイブ動画閲覧\n・オンライン交流会\n・オフ会';
			case 'price.lPFeature2': return 'コミュニティの全機能に加えて\n・限定教材での学習';
			case 'price.lPFeature3': return '課題学習の全機能に加えて\n・ライトサポート付き';
			case 'price.lPFeature4': return '課題学習の全機能に加えて\n・フルサポート付き\n・GitHubでテキスト質問可能\n・2,860円のFlutter入門書プレゼント';
			case 'price.lPFeature5': return '課題学習の全機能に加えて\n・Gemini 2.5 Proに質問し放題\n・モバイル歴10年の人間講師もサポート\n・2,860円のFlutter入門書プレゼント';
			case 'price.yen': return '円';
			case 'price.yen_per_month': return ' 円 / 月';
			case 'price.month': return '月';
			case 'price.threeMonth': return '3ヶ月';
			case 'price.sixMonth': return '6ヶ月';
			case 'price.year': return '年';
			case 'price.if_convert_to_month': return '月に換算すると';
			case 'price.threeMonthsOff': return '3ヶ月分OFF!!';
			case 'interval.monthly': return '月額';
			case 'interval.threeMonth': return '3ヶ月';
			case 'interval.sixMonth': return '6ヶ月';
			case 'interval.annual': return '年額';
			case 'cta_github': return 'GitHubで始める';
			case 'cta': return 'メールアドレスで始める';
			case 'cta_available_count1': return '現在あと';
			case 'cta_available_count2': return '人受付中';
			case 'cta_no_available': return '今月は締め切りました';
			case 'people.subtitle1': return '講師陣';
			case 'people.subtitle2': return '活躍しているメンバー';
			case 'people.other1': return 'その他合計で';
			case 'people.other2': return '名が参加中！';
			case 'people.slackAPI': return '※毎時間Slack APIで人数を集計';
			case 'people.peoples.kosuke.name': return '三枝 洸介';
			case 'people.peoples.kosuke.nickname': return 'Kosuke';
			case 'people.peoples.kosuke.company': return 'Ubie株式会社';
			case 'people.peoples.kosuke.role': return '共同勉強会主催';
			case 'people.peoples.kosuke.description': return '1995年生まれ。福岡県出身。九州大学工学部機械航空工学科卒。卒業後Siemens社のベルギー研究所で機械学習系の研究業務に従事。その後、Web,Flutterエンジニアとして、atama plus株式会社、株式会社SODA等を経て株式会社Omiaiで勤務中。FlutterKaigi 2023, FlutterNinjas 2024などで登壇。複数のpub パッケージの開発者。一緒に楽しく技術を学びましょう！';
			case 'people.peoples.daigo.name': return '若林 大剛';
			case 'people.peoples.daigo.nickname': return 'ダイゴ';
			case 'people.peoples.daigo.company': return 'フリーランス（NPO支援「エイドル」開発他）';
			case 'people.peoples.daigo.role': return 'オンライン交流会主催';
			case 'people.peoples.daigo.description': return '1998年生まれ。大阪出身。大阪体育大学卒業後、ユニクロに入社。2020年10月、kboyに弟子入りするため、ユニクロを退職。大阪から札幌に移住し、Flutterを使ったアプリ開発を手伝う。１年間の修行期間を経て2021年10月からFlutterのフリーランスエンジニアとして活躍、エイドルを始め複数のアプリ開発プロジェクトに参画している。Flutter大学では、オンライン交流会の主催、FlutterGakkaiの運営など多角的に活動している。指導では、初心者に近い存在としてわかりやすいアドバイスや記事執筆に定評がある。初心者のみなさん一緒に頑張りましょう！';
			case 'people.peoples.kboy.name': return '藤川 慶';
			case 'people.peoples.kboy.nickname': return 'kboy';
			case 'people.peoples.kboy.company': return '株式会社KBOY代表取締役社長';
			case 'people.peoples.kboy.role': return '創設者';
			case 'people.peoples.kboy.description': return '1991年生まれ。札幌出身。早稲田大学創造理工学部総合機械工学科卒。プロトコーポレーションでフリマアプリの開発ディレクターを経験後エンジニアに転向し、JX通信社で「NewsDigest」、GraffityにてARアプリ「ペチャバト」の開発を経験。１年半のフリーランス期間を経て、2020年6月に現在の株式会社KBOYを創業。同時期にFlutter大学をスタート。「ゼロから学ぶFlutterアプリ開発」著者。一緒にアプリを作って成功させましょう！';
			case 'people.peoples.masaki.name': return '佐藤 将来';
			case 'people.peoples.masaki.nickname': return 'Masaki';
			case 'people.peoples.masaki.company': return 'フリーランス';
			case 'people.peoples.masaki.role': return '個人開発プロジェクト主宰';
			case 'people.peoples.masaki.description': return '1995年生まれ。愛知県出身。明治大学国際日本学部卒。在学中、特定非営利活動法人アイセック・ジャパンにて海外インターンシップを経験、台湾の英語教育スタートアップにてマーケティング業務にも携わる。その後、大学時代の友人とサービス立ち上げに複数取り組むが、いずれも失敗。その間、UberEats等で生計を立てていた。現在は、フリーランスFlutterエンジニアとして活動しながら、自身のアプリを開発中。Flutterを通して、自分のアイデアを形にしていきましょう！';
			case 'people.peoples.uetomo.name': return '上野 智弘';
			case 'people.peoples.uetomo.nickname': return 'うえとも';
			case 'people.peoples.uetomo.company': return 'フリーランス';
			case 'people.peoples.uetomo.role': return 'オフ会担当';
			case 'people.peoples.uetomo.description': return '1993年生まれ。山形県出身。学生時代は野球に打ち込み、全国軟式野球選手権大会ベスト8、国体出場。水道会社、ラーメン店副店長を経て、地元の友人がIT関連で起業したことがキッカケでプログラミングを学習する為にセブ島に留学する。現在は、Flutterエンジニアとして活動している。趣味のダンスでは、ももいろクローバーZ公式のフリコピ大会にも出場し、審査員特別賞を2回受賞する。楽しいことが大好きなので、エンジニア同士交流して横の繋がりを深めていきましょう！期待してるよ。';
			case 'people.peoples.tokkuu.name': return '徳田 真之介';
			case 'people.peoples.tokkuu.nickname': return 'tokkuu';
			case 'people.peoples.tokkuu.company': return '株式会社メルカリ';
			case 'people.peoples.tokkuu.role': return 'AWS, LINE担当';
			case 'people.peoples.tokkuu.description': return '1991年生まれ。福岡出身。九州大学理学部物理学科卒業後、都内SIerにてインフラエンジニアを5年間経験。その後ミロゴス株式会社を経て株式会社サイバーエージェントにJoin。フロントエンド、バックエンド、インフラやPMなどフルスタックにこなすエンジニアとして従事中。好きな技術はFlutter/Next.js/Node.js/AWS CDK/AWS Lambda/Firebase。大学時代にはバンドマンとしてアルバムを2作自主リリースし、ツアーを実施する傍ら、塾講師・家庭教師などを経験し、人に教えるのも大好き。';
			case 'people.peoples.cobo.name': return '小堀内 志';
			case 'people.peoples.cobo.nickname': return 'cobo';
			case 'people.peoples.cobo.company': return 'クラウドエース株式会社';
			case 'people.peoples.cobo.role': return '講師';
			case 'people.peoples.cobo.description': return '1998年生まれ。岩手県出身。2年制情報系専門学校を卒業後、県内のSIerに就職し、4年間電子カルテシステムの開発に携わる。その後エンジニア同士の繋がりと自身の技術領域を広げるために上京し、クラウドエース株式会社にてGoogle Cloudのスキルを習得中。趣味は弾き語りや音楽制作。kboyのYouTubeのBGMは彼が制作しています。楽しく学習できる環境作りを心がけていきます！';
			case 'people.peoples.gan.name': return '岩本 崚汰';
			case 'people.peoples.gan.nickname': return 'gan';
			case 'people.peoples.gan.company': return 'フリーランス（NPO支援「エイドル」開発他）';
			case 'people.peoples.gan.role': return '講師';
			case 'people.peoples.gan.description': return '2000年生まれ。埼玉県出身。新潟大学理学部理学科数学プログラム卒。現在は同大学大学院の修士課程2年で応用数学の理論（凸解析学における漸近挙動）を研究中。また、2021年4月よりフリーランスとしてFlutter製のNPO支援アプリ「エイドル」の開発に参画している。Flutter大学では2023年2月に新潟オフ会を主催。趣味はバドミントン。質問者に寄り添ったコミュニケーションができるよう頑張っていきます！';
			case 'people.peoples.ota.name': return '太田 龍之介';
			case 'people.peoples.ota.nickname': return 'ryu';
			case 'people.peoples.ota.company': return '株式会社VISIONARY JAPAN';
			case 'people.peoples.ota.role': return '講師';
			case 'people.peoples.ota.description': return '1991年、静岡県生まれ。独学で異業種からスタートアップの会社に転職。FlutterエンジニアとしてFlutter webとFirebaseを用いたtoB向けのカスタマーサクセス専門サービスの開発に従事。現在は、株式会社VISIONARY JAPANで様々な案件に参画。個人開発の成果として、うさぎの体調管理用アプリ「うさぎDiary」をリリース。「うさぎの気持ち」という雑誌に掲載される。初学者に寄り添って開発のサポートができるように頑張ります！';
			case 'people.peoples.heyhey.name': return '小川 将平';
			case 'people.peoples.heyhey.nickname': return 'heyhey';
			case 'people.peoples.heyhey.company': return '株式会社マネーフォワード';
			case 'people.peoples.heyhey.role': return '記事や登壇でコミュニティをリード';
			case 'people.peoples.heyhey.description': return '1984年生まれ。石川県金沢に生まれ、その後高校まで海外を転々とする。上智大学比較文化学科卒。10年近く商社、メーカーの営業を経験後、エンジニアに転身。４年間フードテック系スタートアップでモバイルエンジニアとして従事した後、2023年 5月より株式会社マネーフォワードにてFlutterエンジニアとして勤務。英語とFlutterだけが強みの遅咲きエンジニア。使ってきた技術はFlutter/Dart/Firebase/Node.js/Typescript。最近ではAIやWeb３関連の技術にハマってます。';
			case 'people.peoples.minn.name': return '北山 史織';
			case 'people.peoples.minn.nickname': return 'minn';
			case 'people.peoples.minn.company': return '株式会社プラゴ';
			case 'people.peoples.minn.role': return '講師';
			case 'people.peoples.minn.description': return '2001年生まれ。青森県出身。高校卒業後上京し、Sler企業に一般事務として勤務。会社の同僚から勧められたのがきっかけでプログラミングを学習し、個人開発で画像のコレクションアプリをリリース。2022年7月に未経験からFlutterエンジニアへ転身し、AxiaWorksLLCで様々な案件に参画。現在は株式会社プラゴにてエンジニアを行う。仕事のできるカッコいい女性エンジニアを目指して日々努力しています。楽しく学んで一緒に成長していきましょう！';
			case 'people.peoples.odaken.name': return '小田剣';
			case 'people.peoples.odaken.nickname': return 'おだけん';
			case 'people.peoples.odaken.company': return 'フリーランス（NPO支援「エイドル」開発他）';
			case 'people.peoples.odaken.role': return '講師';
			case 'people.peoples.odaken.description': return '1998年生まれ。佐賀県出身。専修大学経営学部経営学科卒。小学生から大学生までラグビーに打ち込み、全国国体４位を経験。大学卒業後は、ネットワークエンジニアとして就職、3社経験をした後、現在はFlutterエンジニアとして活動している。Flutter製のNPO支援アプリ「エイドル」の開発に参画し、テックフォードアカデミーにて講師を担当している。アプリ開発の楽しさをお伝えできるようサポート頑張ります！';
			case 'people.peoples.miyajic.name': return '宮路 洸';
			case 'people.peoples.miyajic.nickname': return 'みやジック';
			case 'people.peoples.miyajic.company': return '株式会社SODA';
			case 'people.peoples.miyajic.role': return '講師';
			case 'people.peoples.miyajic.description': return '1997年生まれ、愛知県出身。\n北海道大学情報科学院を卒業後、チームラボ株式会社に新卒で入社しスマホアプリエンジニアとして勤務中。学生時代からFlutter大学に参加し、共同開発ではスキ街を発案し継続中に開発中！\n楽しく開発や勉強のサポートをしていきたいと思います！';
			case 'people.peoples.aoi.name': return '東 優太';
			case 'people.peoples.aoi.nickname': return 'Aoi Umigishi';
			case 'people.peoples.aoi.company': return 'フリーランス';
			case 'people.peoples.aoi.role': return '講師';
			case 'people.peoples.aoi.description': return '1992年生まれ。千葉出身。早稲田大学大学院基幹理工学研究科数学応用数理専攻卒。卒業後、トランス・コスモス株式会社に入社し、3次元CADを用いた機械部品設計エンジニアとして従事。「世界中の誰かが、自分の作ったアプリで笑顔になってほしい」という思いから、退職後、個人アプリ開発を開始し、半年で5つのFlutterアプリをリリース、フリーランスエンジニアとなる。Flutter大学のオウンドメディア「週刊Flutter大学」の運営、記事執筆も担当。「自走できるエンジニア化」を手助けします！';
			case 'people.peoples.naoki.name': return '若田 直希';
			case 'people.peoples.naoki.nickname': return 'わかなお';
			case 'people.peoples.naoki.company': return '株式会社Retty';
			case 'people.peoples.naoki.role': return '個人開発者の星';
			case 'people.peoples.naoki.description': return '1998年生まれ。北海道出身。北海道大学農学院卒。好きな食べ物バナナ。\n在学中にFlutter大学に入会しプログラミング学習を開始。卒業後、株式会社Rettyに入社しモバイルアプリチームでAndroidエンジニアとして日々奮闘中。個人開発ではFlutterで二郎系ラーメンに関するアプリを運用中で1日のユーザー数100人を達成。';
			case 'people.peoples.kenty.name': return '戸倉 健';
			case 'people.peoples.kenty.nickname': return 'kenty';
			case 'people.peoples.kenty.company': return 'フリーランス';
			case 'people.peoples.kenty.role': return '講師';
			case 'people.peoples.kenty.description': return '1997年生まれ、埼玉県出身。千葉工業大学未来ロボティクス学科を卒業後、ダイアモンドヘッド株式会社に入社し、アパレル業界向けのECサービス開発に3年従事。2024年からフリーランスに転身し、Webサイト制作、Flutterアプリ(iOS, Android, Linux) 、講師業務など幅広い分野で活動中。2024年3月に株式会社ワンアーカーのテックリードに就任。実は個人でリリースしたアプリがないので、皆さんと一緒に学びながら開発したいと思ってます！乞うご期待！';
			case 'people.peoples.fen.name': return '上田 賢志';
			case 'people.peoples.fen.nickname': return 'fen';
			case 'people.peoples.fen.company': return 'フリーランス';
			case 'people.peoples.fen.role': return '講師';
			case 'people.peoples.fen.description': return '2003年生まれ。福岡県出身。2022年にFlutter大学に参加し、Flutterシェアハウスや Flutter別荘で Flutter を学びフリーランスとして活動中。未経験から Flutter に触れ始め、躓いたところや苦しんだところなどたくさんの経験があるので、知見の共有や技術的なサポートをしてきたいと思います！個人開発ではネイティブ特有の機能を Flutter で利用できるような実装をやってます。趣味は麻雀と将棋です！';
			case 'voice.description': return 'Flutter大学について書かれた\nnoteやブログをご紹介します。';
			case 'projects.subtitle': return 'メンバーによる様々な取り組み';
			case 'projects.flutter_house.title': return 'Flutterハウス';
			case 'projects.flutter_house.description': return 'Flutterハウスは、こんぶさんが立ち上げたFlutterエンジニアによるFlutterエンジニアのためのシェアハウス。某恋愛リアリティショーを意識して「フラハ」と呼ばれています。東京恵比寿にあるアパートの１室で4~6人のエンジニアが暮らしていて、仕事から遊びまで全力で楽しんでいます。月１でUTAGEと呼ばれる飲み会も開催中。Flutter大学メンバーが気軽に立ち寄れる東京の拠点です。';
			case 'projects.flutter_house.dateDescription': return '2020年10月~';
			case 'projects.flutter_gakkai.title': return 'FlutterGakkai';
			case 'projects.flutter_gakkai.description': return 'FlutterGakkaiは、Flutterエンジニアのための勉強会です。以前からFlutter大学内では共同勉強会を行っていましたが、Flutter大学内に止まらず日本のFlutter界隈を盛り上げようということで立ち上がったオンライン勉強会です。今まで２回オンラインで開催しました。将来的にはオフラインで大々的に開催することを目指しています。';
			case 'projects.flutter_gakkai.dateDescription': return '2022年1月~';
			case 'projects.weekly_flutter_university.title': return '週刊Flutter大学';
			case 'projects.weekly_flutter_university.description': return '週刊Flutter大学は、Aoiさんが編集長として始めたWEBメディアです。毎週更新される「今週のFlutterニュース」では常にFlutterの最新情報をキャッチアップできます。また、Flutter公式の最新リリースの際には最速で日本語まとめ記事をリリースしており、日本のFlutterメディアを牽引しています。';
			case 'projects.weekly_flutter_university.dateDescription': return '2022年3月~';
			case 'projects.hackathon_victory.title': return 'ハッカソン優勝';
			case 'projects.hackathon_victory.description': return 'Flutter大学内でチームを組んでハッカソンに出場しています。先日行われたSpajam2022第一回予選ではFlutterLoversが最優秀賞を獲得しました。Flutter×Firebaseのスキルセットは、開発スピードが早く、ハッカソン向きだと思われます。今後もその他のチームの出場予定があり期待が高まります。';
			case 'projects.hackathon_victory.dateDescription': return '2022年8月';
			case 'projects.flutter_villa.title': return 'Flutter別荘';
			case 'projects.flutter_villa.description': return 'Flutter別荘は、こんぶさんが滋賀県東近江市の古民家を購入したことによりスタートしました。Flutterハウスに次ぐ第２のシェアハウスでもあり、今後Flutter合宿を行う拠点としても期待されています。庭には手作りサウナ小屋があり、車庫にパワーラックを持つジムがあり、そして高速Wifiもございます。事前に連絡することで泊まりにいくことが可能です。';
			case 'projects.flutter_villa.dateDescription': return '2022年8月~';
			case 'projects.flutter_women.title': return 'Flutter女子';
			case 'projects.flutter_women.description': return 'Flutter大学の女子メンバーが定期的に集まって女子会をしたり、アプリ開発を行っています。現在、Flutter女子チームでクリスマスに向けたアプリを共同開発中！';
			case 'projects.flutter_women.dateDescription': return '2022年10月~';
			case 'projects.xx_dart.title': return '〇〇.dart';
			case 'projects.xx_dart.description': return '「地域×Flutter」というコンセプトのもと、〇〇.dartというFlutter勉強会を開催しています。Flutter大学に入っている人だけでなく、興味のある方々にも参加していただけます。5月には大阪.dart、6月には東京.dartが開催される予定です。北海道.dartも8月のビアガーデンシーズンに開催予定です。';
			case 'projects.xx_dart.dateDescription': return '2023年3月~';
			case 'projects.morning_mokumoku.title': return '朝のもくもく会';
			case 'projects.morning_mokumoku.description': return '入る場所は、gatherというバーチャル上のワークスペースです。毎朝7:10~8:00まで、gather上のテーブルで一緒にもくもくと作業をして、8:00になったら左下のテーブルに集まって、今日やったことを報告して終了です。早起きしてみんなで作業する習慣付けに活用しています。';
			case 'projects.morning_mokumoku.dateDescription': return '2023年4月~';
			case 'projects.tokyo_flutter_hackathon.title': return '東京Flutterハッカソン';
			case 'projects.tokyo_flutter_hackathon.description': return 'Flutter大学と株式会社ゆめみの共同で、「東京Flutterハッカソン」を9/30,10/1の2日間で開催しました。多くの企業さんにスポンサーに入っていただき、またサイバーエージェントさんの会場もお借りして開催することができました。参加者はなんと100人超えで参加チームは23チームにおよびました。';
			case 'projects.tokyo_flutter_hackathon.dateDescription': return '2023年9月';
			case 'projects.terakoya.title': return 'テラコヤテック';
			case 'projects.terakoya.description': return 'テラコヤテックは、これからのエンジニアのスキルとして需要の高いツール・言語を6ヶ月で習得できる、エンジニア養成プログラムです。採択制。完全無料。リツアンSTCさんとクラウドテックさんとFlutter大学がコラボして行われました。';
			case 'projects.terakoya.dateDescription': return '2023年12月~2024年5月';
			case 'projects.flutter_book.title': return 'ゼロから学ぶFlutterアプリ開発の出版';
			case 'projects.flutter_book.description': return 'Flutter大学の創業者kboyが技術評論社からFlutterの入門書を出版しました。';
			case 'projects.flutter_book.dateDescription': return '2023年12月';
			case 'projects.global_gamers_challenge.title': return 'Global Gamers Challengeで日本優勝';
			case 'projects.global_gamers_challenge.description': return 'Global Gamers ChallengeというFlutter公式が主催するハッカソンで、みやじっくさんとkazukiさんのチームが作ったTurtle escapeがGoogle Wallet - Best Integration in Japanese - 1st placeに輝き、7,500USDの賞金を獲得しました！';
			case 'projects.global_gamers_challenge.dateDescription': return '2024年5月';
			case 'projects.flutter_ninjas.title': return 'FlutterNinjas Tokyo 2024';
			case 'projects.flutter_ninjas.description': return 'Flutter大学メンバーがオーガナイザーとなり、FlutterNinjasという日本初の英語のFlutterカンファレンスを開催しました。Riverpod開発者のRemiさんをはじめ、多くの著名なFlutterエンジニアが世界から集まりました。';
			case 'projects.flutter_ninjas.dateDescription': return '2024年6月';
			case 'media.subtitle': return 'メディア掲載';
			case 'join.subtitle': return '入学の流れ';
			case 'join.joinSteps.step01.title': return 'GitHub認証';
			case 'join.joinSteps.step02.title': return 'プランを選択して決済';
			case 'join.joinSteps.step03.title': return 'Slackにて1on1のご案内';
			case 'join.joinSteps.step03.titleMobile': return 'Slackにて\n1on1のご案内';
			case 'qa.subtitle': return 'よくある質問';
			case 'qa.qaList.0.q': return '初心者ですが、大丈夫ですか？';
			case 'qa.qaList.0.a': return '大丈夫です。\nFlutter大学では初心者から中級者の方まで幅広くサポートしています。';
			case 'qa.qaList.1.q': return '初心者はHTML等から始めるべきですか？';
			case 'qa.qaList.1.a': return 'いいえ。Flutterから始めて大丈夫です。\nもちろん知っているに越したことはありませんがFlutterから始めてバリバリ活躍されている方も多いのでご安心ください。';
			case 'qa.qaList.2.q': return 'Windowsですが、大丈夫ですか？';
			case 'qa.qaList.2.a': return '大丈夫です。\nしかし、WindowsですとiPhoneアプリのデバッグができないのでMacの方がオススメです。';
			case 'qa.qaList.3.q': return '競合他社との違いはなんですか？';
			case 'qa.qaList.3.a': return 'メンバーの質で負けない自信があります。\nFlutter大学は2020年4月からスタートし、メンバーと共に進化を重ねてきました。';
			case 'qa.qaList.4.q': return '現役エンジニアは入る意味ありますか？';
			case 'qa.qaList.4.a': return '実はFlutter大学のメンバーの7割以上が現役エンジニアで、エンジニア仲間を作る目的で入られる方も多いです。\nコミュニティプランに入り、勉強会や共同開発、オンライン交流会、オフ会、その他のプロジェクトを通してエンジニア仲間を作りましょう！';
			case 'qa.qaList.5.q': return '入会後のお問い合わせ先は？';
			case 'qa.qaList.5.a': return 'Flutter大学アプリのお問い合わせページからお問い合わせください。';
			case 'qa.qaList.6.q': return '決済方法について教えてください';
			case 'qa.qaList.6.a': return 'クレジットカード(VISA, JCB, MASTER, AMEX)でのお支払いに対応しております。\n入会日を起点とし、１ヶ月ごとに定期決済されます。';
			case 'qa.qaList.7.q': return '法人でも活用できますか？';
			case 'qa.qaList.7.a': return '法人様の活用事例もございます。\n詳しくは右下のお問い合わせからご連絡をお願いいたします。';
			case 'qa.qaList.8.q': return '退会方法は？';
			case 'qa.qaList.8.a': return 'Flutter大学アプリのお問い合わせページからボタン一つで退会できます。\n面倒な電話問い合わせ等はございません。';
			case 'message.title': return 'Flutter大学コミュニティの価値とは？';
			case 'message.message': return '技術の急速な進歩により、アプリ開発の手法は日々変化していますが、Flutter大学では単なる技術習得を超えた価値を大切にしています。\n\n私たちが最も重視するのは、メンバー一人ひとりが互いの成長を支え合う「学び合いのコミュニティ」です。\n\n質問や課題を一人で抱え込むのではなく、経験豊富なメンバーが惜しみなく知識を共有し、初心者の方でも安心して学習を進められる環境を築いてきました。\n\n共同開発やオンライン勉強会を通じて、個人の学習だけでは得られない実践的なスキルと、何よりも貴重な人とのつながりを育んでいます。\n\n私たちと一緒に、技術と人とのつながりを大切にした学習コミュニティを築いていきませんか？\n\nFlutter大学代表\n藤川慶';
			case 'newMembers.dayAgo': return '日前';
			case 'newMembers.hourAgo': return '時間前';
			case 'newMembers.minuteAgo': return '分前';
			case 'newMembers.secondAgo': return '秒前';
			case 'newMembers.future': return '将来的';
			case 'newMembers.ni': return 'に、';
			case 'newMembers.joined': return 'さんが入会しました！';
			case 'menu.developmentExperience': return '開発実績';
			case 'menu.threeFeatures': return '3つの特徴';
			case 'menu.pricePlan': return '料金プラン';
			case 'menu.members': return 'メンバー';
			case 'menu.memberVoice': return 'メンバーの声';
			case 'menu.enrollmentProcess': return '入学の流れ';
			case 'menu.faq': return 'よくある質問';
			case 'menu.login': return 'ログイン';
			case 'footer.terms': return '利用規約';
			case 'footer.tokusho': return '特定商取引法に基づく表記';
			case 'footer.privacyPolicy': return 'プライバシーポリシー';
			case 'footer.operatingCompany': return '運営会社';
			case 'underMaintenance': return '現在メンテナンス中です';
			case 'schedule.title': return 'スケジュール予約';
			case 'schedule.description': return 'AIと人間講師に同時に聞ける\n個別相談やメンタリングのスケジュール予約は\nCalendlyページから行ってください。';
			case 'schedule.calendlyButton': return 'Calendlyで予約する';
			default: return null;
		}
	}
}
