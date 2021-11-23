import 'package:intl/intl.dart';

// ********
// homepage
String getAppTitle() => Intl.message('Ubuntu Accomplishments',
    name: 'getAppTitle', desc: 'The title of this application');

String getSettingsTitle() => Intl.message('Settings',
    name: 'getSettingsTitle', desc: 'The title of the settings page');

String getMyTrophiesTitle() => Intl.message('My Trophies',
    name: 'getMyTrophiesTitle',
    desc: 'The title of the My Trophies button and page');

String getOpportunitiesTitle() => Intl.message('Opportunities',
    name: 'getOpportunitiesTitle',
    desc: 'The title of the Opportunities button and page');

// *************
// settings page
String getCheckingAccomplishmentsMessage() =>
    Intl.message('Checking for accomplishments.',
        name: 'getCheckingAccomplishmentsMessage',
        desc: 'The text displayed when we check for accomplishments');

String getCheckAccomplishmentsButton() => Intl.message('Check accomplishments',
    name: 'getCheckAccomplishmentsButton',
    desc:
        'The text displayed on the button that requests a recheck of accomplishments');

String getReloadingAccomplishmentsMessage() =>
    Intl.message('Reloading collections.',
        name: 'getReloadingAccomplishmentsMessage',
        desc: 'The text displayed when we reload accomplishment definitions');

String getReloadAccomplishmentsButton() => Intl.message(
    'Reload accomplishment definitions',
    name: 'getReloadAccomplishmentsButton',
    desc:
        'The text displayed on the button that requests a reload of accomplishment definitions');

String getExtraInformationText() => Intl.message('Extra information',
    name: 'getExtraInformationText',
    desc: 'The heading of the extra information panel in settings');

String getSettingsSavedMessage() => Intl.message('Settings saved.',
    name: 'getSettingsSavedMessage',
    desc: 'The text displayed when the settings are saved');

// **************
// extrainfo form
String getLaunchpadUsernameFieldHint() =>
    Intl.message('Enter your launchpad.net username',
        name: 'getLaunchpadUsernameFieldHint',
        desc: 'The hint on the Launchpad Username input field');

String getLaunchpadUsernameFieldEmptyMessage() => Intl.message(
    'Please enter your launchpad.net username',
    name: 'getLaunchpadUsernameFieldEmptyMessage',
    desc:
        'The validation message displayed if the Launchpad Email address is left empty when saving extra information');

// **************
// trophy details
String getDescriptionTitle() => Intl.message('Description:',
    name: 'getDescriptionTitle',
    desc:
        'The title of the Trophy Description row of the Trophy Details screen');

String getTrophyScreenTitle(String trophyName) =>
    Intl.message('Trophy Details: $trophyName',
        name: 'getTrophyScreenTitle',
        args: [trophyName],
        desc: 'The title used on the Trophy details screen',
        examples: const {'trophyName': 'Approved Ubuntu Member'});

String getSummaryTitle() => Intl.message('About the trophy:',
    name: 'getSummaryTitle',
    desc: 'The title of the Summary row of the Trophy Details screen');

String getTrophyDependencies(String dependencies) => Intl.message(
    'This trophy is currently locked because you have not accomplished $dependencies yet.',
    name: 'getTrophyDependencies',
    args: [dependencies],
    desc:
        'The trophies that this trophy requires to be accomplished before unlocking',
    examples: const {
      'dependencies':
          'ubuntu-community/ubuntu-member, ubuntu-community/imported-ssh-key'
    });

String getStepsTitle() => Intl.message('Steps to complete for this trophy:',
    name: 'getStepsTitle',
    desc:
        'The title of the Steps-to-Complete row of the Trophy Details screen');

String getTipsTitle() => Intl.message('Tips:',
    name: 'getTipsTitle',
    desc: 'The title of the Tips row of the Trophy Details screen');

String getPitfallsTitle() => Intl.message('Pitfalls:',
    name: 'getPitfallsTitle',
    desc: 'The title of the Pitfalls row of the Trophy Details screen');

String getRelevantLinksTitle() => Intl.message('Relevant links:',
    name: 'getRelevantLinksTitle',
    desc: 'The ttitle of the Relevant Links row of the Trophy Details screen');

String getFurtherHelpTitle() => Intl.message('Further help can be found at:',
    name: 'getFurtherHelpTitle',
    desc: 'The title of the Further Help row of the Trophy Details screen');

String getTrophyAuthor(String name) =>
    Intl.message('This trophy was contributed by $name',
        name: 'getTrophyAuthor',
        args: [name],
        desc: 'The author of a trophy',
        examples: const {'name': 'Dani Llewellyn <diddledani@ubuntu.com>'});

String getCannotLaunchUrlText(String url) =>
    Intl.message('Could not launch $url',
        name: 'getCannotLaunchUrlText',
        args: [url],
        desc: 'Text displayed when we cannot launch a URL',
        examples: const {'url': 'https://example.com/'});

// *****
// forms
String getSaveText() => Intl.message('Save',
    name: 'getSaveText', desc: 'The text shown on save buttons');

String getInvalidInputNamed(fieldName) =>
    Intl.message('Please enter a valid $fieldName',
        name: 'getInvalidInputNamed',
        args: [fieldName],
        desc: 'The text shown when a form field has invalid content',
        examples: {'fieldName': 'Ask Ubuntu Profile URL'});

// ******
// Errors
String getErrorText(String message) => Intl.message('Error: $message',
    name: 'getErrorText',
    args: [message],
    desc: 'Text displayed when we hit an error');
