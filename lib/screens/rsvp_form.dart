import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wedding_website/api/sheets/rsvp_sheets_api.dart';
import 'package:wedding_website/model/guests.dart';

class _PartyMember {
  final String name;
  String ceremony;
  String reception;
  final TextEditingController dietaryController;
  bool isExpanded;

  _PartyMember({
    required this.name,
    required this.ceremony,
    required this.reception,
    required String dietary,
    required this.isExpanded,
  }) : dietaryController = TextEditingController(text: dietary);
}

class RsvpForm extends StatefulWidget {
  final Guest? guest;
  const RsvpForm({super.key, this.guest});
  @override
  RsvpFormState createState() => RsvpFormState();
}

class RsvpFormState extends State<RsvpForm> {
  static const Color backgroundColor = Color.fromRGBO(104, 115, 81, 1);
  static const Color creamColor = Color(0xFFF3F0E7);
  static const Color errorColor = Color(0xFFF4C868);
  static const List<String> attendanceOptions = ['', 'Yes', 'No'];

  final formKey = GlobalKey<FormState>();
  final nameFieldKey = GlobalKey<FormFieldState<String>>();
  late TextEditingController controllerName;

  Guest? primaryGuest;
  List<_PartyMember> _party = [];

  // The (normalized) name Confirm has already resolved and shown for
  // review. Lets the first Confirm reveal the party fields without
  // immediately flagging them as unanswered — a second Confirm submits.
  String? _resolvedForName;

  int _validationRequestId = 0;

  @override
  void initState() {
    super.initState();

    controllerName = TextEditingController();
    _resetFieldsFromGuest(widget.guest);
  }

  @override
  void didUpdateWidget(covariant RsvpForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only reset if the guest actually changed, so we don't blow away
    // in-progress user input (and cursor position) on unrelated rebuilds.
    if (oldWidget.guest?.name != widget.guest?.name) {
      _resetFieldsFromGuest(widget.guest);
    }
  }

  @override
  void dispose() {
    controllerName.dispose();
    for (final member in _party) {
      member.dietaryController.dispose();
    }
    super.dispose();
  }

  void _resetFieldsFromGuest(Guest? g) {
    controllerName.text = g?.name ?? controllerName.text;
    primaryGuest = g;
    _setParty(g == null ? [] : [g]);

    if (mounted) setState(() {});
  }

  // Replaces the party list, disposing the previous members' controllers.
  // Cards all start collapsed so the user chooses who to answer for first.
  // The primary guest (the name that was typed in) is always shown first.
  void _setParty(List<Guest> guests) {
    for (final member in _party) {
      member.dietaryController.dispose();
    }
    final normalizedPrimaryName = primaryGuest?.name.trim().toLowerCase();
    bool isPrimary(Guest g) =>
        g.name.trim().toLowerCase() == normalizedPrimaryName;
    final sortedGuests = [
      ...guests.where(isPrimary),
      ...guests.where((g) => !isPrimary(g)),
    ];
    _party = sortedGuests
        .map((g) => _PartyMember(
              name: g.name,
              ceremony: g.ceremony,
              reception: g.reception,
              dietary: g.dietary ?? '',
              isExpanded: false,
            ))
        .toList();
  }

  Future<void> validateName() async {
    final requestId = ++_validationRequestId;
    final name = controllerName.text;

    final (result, guests) = await RsvpSheetsApi.getGuestAndParty(name);

    // Bail out if the widget was disposed or a newer request has since
    // superseded this one (avoids stale-response race conditions).
    if (!mounted || requestId != _validationRequestId) return;

    setState(() {
      primaryGuest = result;
      _setParty(guests);
    });
  }

  bool isDesktopWidth(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;

  bool isMobileWidth(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  double fieldTextSize(BuildContext context) =>
      screenWidth(context) > 975 ? 18.0 : 18.0;
  double responseTextSize(BuildContext context) =>
      screenWidth(context) > 975 ? 18.0 : 18.0;
  double buttonTextSize(BuildContext context) =>
      screenWidth(context) > 975 ? 25.0 : 21.0;

  InputDecoration _underlineDecoration(
      {String? hintText, bool filled = false, Color? fillColor}) {
    return InputDecoration(
      filled: filled,
      fillColor: fillColor,
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: creamColor.withValues(alpha: 0.8))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: creamColor.withValues(alpha: 0.8))),
      errorBorder:
          const UnderlineInputBorder(borderSide: BorderSide(color: errorColor)),
      focusedErrorBorder:
          const UnderlineInputBorder(borderSide: BorderSide(color: errorColor)),
      hintText: hintText,
      hintStyle: TextStyle(
          fontSize: 15.0, color: creamColor.withValues(alpha: 0.6)),
      errorStyle: const TextStyle(color: errorColor),
    );
  }

  Widget _title(BuildContext context) {
    double titleTextSize = screenWidth(context) > 975 ? 60.0 : 48.0;
    double dateTextSize = screenWidth(context) > 975 ? 20.0 : 18.0;

    return Column(
      children: [
        Text(
          'RSVP',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Madelyn',
            fontSize: titleTextSize,
            color: creamColor,
          ),
        ),
        Text("Please RSVP by December 13th",
            style: TextStyle(
                fontSize: dateTextSize,
                fontWeight: FontWeight.normal,
                color: creamColor)),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _name(BuildContext context) {
    double nameHintSize = screenWidth(context) > 975 ? 18.0 : 18.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
        width: 280,
        child: TextFormField(
          key: nameFieldKey,
          style: TextStyle(
              fontSize: responseTextSize(context), color: creamColor),
          controller: controllerName,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _handleSubmit(context),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: creamColor.withValues(alpha: 0.8))),
            focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: creamColor.withValues(alpha: 0.8))),
            errorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: errorColor)),
            focusedErrorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: errorColor)),
            hintStyle: TextStyle(
                fontSize: nameHintSize,
                color: creamColor.withValues(alpha: 0.6)),
            hintText: "Your first and last name",
            errorStyle: const TextStyle(color: errorColor),
          ),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return "Please enter your name";
            } else if (primaryGuest != null) {
              return null;
            } else if (value != null && !value.contains(" ")) {
              return "Please enter your first and last name";
            } else {
              return "We can't seem to find your invite. \nPlease try another spelling or contact us directly.";
            }
          },
        ),
        ),
      ],
    );
  }

  String _initials(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  Widget _avatar(_PartyMember member) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: creamColor.withValues(alpha: 0.08),
        border: Border.all(color: creamColor.withValues(alpha: 0.55)),
      ),
      child: Text(
        _initials(member.name),
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: creamColor,
        ),
      ),
    );
  }

  String _statusText(_PartyMember member) {
    final hasCeremony = member.ceremony.isNotEmpty;
    final hasReception = member.reception.isNotEmpty;

    if (!hasCeremony && !hasReception) return "Not answered yet";
    if (hasCeremony && hasReception) {
      return "Ceremony ${member.ceremony} · Reception ${member.reception}";
    }
    if (hasCeremony) return "Ceremony ${member.ceremony} · Reception not answered";
    return "Reception ${member.reception} · Ceremony not answered";
  }

  Widget _partyList(BuildContext context) {
    if (_party.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_party.length > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Text(
              "Party of ${_party.length}",
              style: TextStyle(
                fontSize: fieldTextSize(context),
                color: creamColor.withValues(alpha: 0.85),
              ),
            ),
          ),
        for (final member in _party) _partyCard(context, member),
      ],
    );
  }

  Widget _partyCard(BuildContext context, _PartyMember member) {
    final isSelf = primaryGuest != null && member.name == primaryGuest!.name;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => member.isExpanded = !member.isExpanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                _avatar(member),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(member.name,
                          style: TextStyle(
                              fontSize: responseTextSize(context),
                              fontWeight: FontWeight.bold,
                              color: creamColor)),
                      const SizedBox(height: 2),
                      Text(
                        _statusText(member),
                        style: TextStyle(
                            fontSize: 12.5,
                            color: creamColor.withValues(alpha: 0.65)),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: member.isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.keyboard_arrow_down_rounded,
                      color: creamColor.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity, height: 0),
          secondChild: Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _partyCeremony(context, member, isSelf),
                const SizedBox(height: 16),
                _partyReception(context, member, isSelf),
                const SizedBox(height: 16),
                _partyDietary(context, member),
              ],
            ),
          ),
          crossFadeState: member.isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
        Divider(color: creamColor.withValues(alpha: 0.2), height: 1),
      ],
    );
  }

  Widget _partyCeremony(
      BuildContext context, _PartyMember member, bool isSelf) {
    final value =
        attendanceOptions.contains(member.ceremony) ? member.ceremony : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Will ${member.name} be attending our wedding ceremony?",
            style: TextStyle(fontSize: fieldTextSize(context))),
        DropdownButtonFormField<String>(
          key: ValueKey('${member.name}-ceremony'),
          initialValue: value,
          onChanged: (value) => setState(() => member.ceremony = value!),
          items: attendanceOptions
              .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(value,
                        style: TextStyle(
                            fontSize: responseTextSize(context),
                            color: backgroundColor)),
                  ))
              .toList(),
          selectedItemBuilder: (context) => attendanceOptions
              .map((value) => Align(
                    alignment: Alignment.centerLeft,
                    child: Text(value,
                        style: TextStyle(
                            fontSize: responseTextSize(context),
                            color: creamColor)),
                  ))
              .toList(),
          decoration: _underlineDecoration(
              filled: value.isNotEmpty,
              fillColor: backgroundColor),
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: creamColor.withValues(alpha: 0.8)),
          iconSize: 30,
          validator: (value) => isSelf && value != null && value.isEmpty
              ? "Please select a response."
              : null,
        ),
      ],
    );
  }

  Widget _partyReception(
      BuildContext context, _PartyMember member, bool isSelf) {
    final value =
        attendanceOptions.contains(member.reception) ? member.reception : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Will ${member.name} be attending our wedding reception?",
            style: TextStyle(fontSize: fieldTextSize(context))),
        DropdownButtonFormField<String>(
          key: ValueKey('${member.name}-reception'),
          initialValue: value,
          onChanged: (value) => setState(() => member.reception = value!),
          items: attendanceOptions
              .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(value,
                        style: TextStyle(
                            fontSize: responseTextSize(context),
                            color: backgroundColor)),
                  ))
              .toList(),
          selectedItemBuilder: (context) => attendanceOptions
              .map((value) => Align(
                    alignment: Alignment.centerLeft,
                    child: Text(value,
                        style: TextStyle(
                            fontSize: responseTextSize(context),
                            color: creamColor)),
                  ))
              .toList(),
          decoration: _underlineDecoration(
              filled: value.isNotEmpty,
              fillColor: backgroundColor),
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: creamColor.withValues(alpha: 0.8)),
          iconSize: 30,
          validator: (value) => isSelf && value != null && value.isEmpty
              ? "Please select a response."
              : null,
        ),
      ],
    );
  }

  Widget _partyDietary(BuildContext context, _PartyMember member) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Dietary requirements for ${member.name}",
            style: TextStyle(fontSize: fieldTextSize(context))),
        TextField(
          key: ValueKey('${member.name}-dietary'),
          style: TextStyle(fontSize: fieldTextSize(context), color: creamColor),
          controller: member.dietaryController,
          decoration: _underlineDecoration(
              hintText: "E.g. food allergies, other (please specify)"),
        ),
      ],
    );
  }

  Future<void> _handleSubmit(BuildContext context) async {
    final typedName = controllerName.text.trim().toLowerCase();
    final isFirstReveal = _resolvedForName != typedName;

    if (isFirstReveal) {
      // Only re-fetch from the sheet on the reveal step. Fetching again
      // on the follow-up submit click would rebuild `_party` from the
      // server's (still blank) data and wipe out whatever the user just
      // typed into the fields before validation even runs.
      await validateName();
      if (!mounted) return;

      // Resolving the name can reveal new party-member fields. Wait for
      // that rebuild to actually happen before validating/returning,
      // otherwise those fields aren't registered with the Form yet and
      // validate() silently skips them.
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;

      if (primaryGuest != null) {
        // Found the invite — show it for review instead of immediately
        // flagging required fields nobody's had a chance to answer yet.
        // A second Confirm (below) actually submits.
        _resolvedForName = typedName;
        // Clear a stale "can't find invite" error left over from an
        // earlier failed attempt, without validating the newly-revealed
        // (and not yet answered) party fields.
        nameFieldKey.currentState?.validate();
        return;
      }
      // Not found — fall through so the "can't find invite" error shows.
    }

    final form = formKey.currentState!;
    final isValid = form.validate();

    if (!isValid) return;

    final submittedParty = List<_PartyMember>.from(_party);

    // Fire the updates first so the confirmation only shows once the
    // writes have actually happened; still guarded by `mounted` below
    // since the user could navigate away while this is in flight.
    await Future.wait([
      for (final member in submittedParty)
        RsvpSheetsApi.update(
          member.name,
          Guest(
            name: member.name,
            ceremony: member.ceremony,
            reception: member.reception,
            dietary: member.dietaryController.text,
          ).toJson(),
        ),
    ]);

    if (!context.mounted) return;

    final partySize = submittedParty.length;

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: creamColor,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 20),
                Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(children: [
                    TextSpan(
                        text: 'Thank you for your RSVP!\n',
                        style: TextStyle(
                            fontSize: fieldTextSize(context),
                            color: backgroundColor)),
                    TextSpan(
                        text: partySize > 1
                            ? '\nWe\'ve recorded responses for your whole party. If you need to update any of your responses, please submit a new RSVP.'
                            : '\nIf you need to update any of your responses, please submit a new RSVP.',
                        style: TextStyle(
                            fontSize: fieldTextSize(context),
                            color: backgroundColor)),
                  ]),
                ),
                const SizedBox(height: 50),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: creamColor,
                      side: BorderSide(color: backgroundColor.withValues(alpha: 0.8))),
                  onPressed: () {
                    Navigator.pop(context); // Close the bottom sheet
                    Navigator.pop(context);
                    if (!mounted) return;
                    setState(() {
                      formKey.currentState!.reset();
                      controllerName.clear();
                      primaryGuest = null;
                      _resolvedForName = null;
                      _setParty([]);
                    });
                  },
                  child: Text("Close",
                      style: TextStyle(
                          fontSize: buttonTextSize(context),
                          fontWeight: FontWeight.normal,
                          color: backgroundColor)),
                ),
              ],
            ),
          );
        });
  }

  Widget _submit(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          side: BorderSide(color: creamColor.withValues(alpha: 0.8))),
      onPressed: () => _handleSubmit(context),
      child: Text("Confirm",
          style: TextStyle(
              fontSize: buttonTextSize(context),
              fontWeight: FontWeight.normal,
              color: creamColor)),
    );
  }

  Widget _cancel(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: BorderSide(color: creamColor.withValues(alpha: 0.8))),
        onPressed: () {
          setState(() {
            formKey.currentState!.reset();
            controllerName.clear();
            primaryGuest = null;
            _resolvedForName = null;
            _setParty([]);
          });
        },
        child: Text("Cancel",
            style: TextStyle(
                fontSize: buttonTextSize(context),
                fontWeight: FontWeight.normal,
                color: creamColor)));
  }

  Widget _buttonRow(BuildContext context) {
    double spaceBetweenButtons = screenWidth(context) > 975 ? 40.0 : 18.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _submit(context),
        SizedBox(width: spaceBetweenButtons),
        _cancel(context)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    bool isDesktop = Theme.of(context).platform == TargetPlatform.windows ||
        Theme.of(context).platform == TargetPlatform.linux ||
        Theme.of(context).platform == TargetPlatform.macOS;

    if (isDesktop && isMobileWidth(context) || (isMobileWidth(context))) {
      return Scaffold(
          appBar: AppBar(
              systemOverlayStyle:
                  const SystemUiOverlayStyle(statusBarColor: Colors.white),
              centerTitle: true,
              backgroundColor: const Color.fromRGBO(243, 240, 231, 0.75),
              elevation: 0,
              scrolledUnderElevation: 4,
              iconTheme: const IconThemeData(color: backgroundColor),
              title: const Text(
                "A & A",
                style: TextStyle(
                    color: backgroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              )),
          body: SingleChildScrollView(
              child: Center(
                  child: Form(
            key: formKey,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding:
                  const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 30),
              child: DefaultTextStyle.merge(
                style: const TextStyle(color: creamColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.1),
                    _title(context),
                    const SizedBox(height: 20),
                    if (_party.isEmpty) ...[
                      _name(context),
                      const SizedBox(height: 32),
                    ],
                    _partyList(context),
                    const SizedBox(height: 48),
                    _buttonRow(context)
                  ],
                ),
              ),
            ),
          ))));
    } else {
      return Scaffold(
          appBar: AppBar(
              systemOverlayStyle:
                  const SystemUiOverlayStyle(statusBarColor: Colors.white),
              centerTitle: true,
              backgroundColor: const Color.fromRGBO(243, 240, 231, 0.75),
              elevation: 0,
              scrolledUnderElevation: 4,
              iconTheme: const IconThemeData(color: backgroundColor),
              title: const Text(
                "A & A",
                style: TextStyle(
                    color: backgroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              )),
          body: SingleChildScrollView(
              child: Center(
                  child: Form(
            key: formKey,
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: screenHeight, maxWidth: 600),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30.0),
                child: DefaultTextStyle.merge(
                  style: const TextStyle(color: creamColor),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _title(context),
                      const SizedBox(height: 20),
                      if (_party.isEmpty) ...[
                        _name(context),
                        const SizedBox(height: 20),
                      ],
                      _partyList(context),
                      const SizedBox(height: 48),
                      _buttonRow(context)
                    ],
                  ),
                ),
              ),
            ),
          ))));
    }
  }
}
