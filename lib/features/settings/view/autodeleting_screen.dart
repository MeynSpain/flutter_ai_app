import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ai/core/constant/constant.dart';
import 'package:flutter_ai/core/injection.dart';
import 'package:flutter_ai/features/settings/bloc/settings_bloc.dart';
import 'package:flutter_ai/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AutoDeletingScreen extends StatefulWidget {
  const AutoDeletingScreen({super.key});

  @override
  State<AutoDeletingScreen> createState() => _AutoDeletingScreenState();
}

class _AutoDeletingScreenState extends State<AutoDeletingScreen> {

  @override
  void initState() {
    getIt<SettingsBloc>().add(SettingsAutoDeleteInitial(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).autodelete),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: Container(
            color: theme.primaryColor,
            height: 2,
          ),
        ),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        bloc: getIt<SettingsBloc>(),
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(
              top: 24,
            ),
            child: ListView.builder(
              itemCount: state.daysList.length,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.only(
                  left: 14,
                  right: 14,
                  top: 5,
                ),
                decoration: ShapeDecoration(
                  color: Color(0xFFF7F7F7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: ListTile(
                  title: Text(
                    state.daysList[index].literalDay,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  trailing: Visibility(
                    visible: state.selectedDaysIndex == index,
                    child: SvgPicture.asset(
                      'assets/icons/accept.svg',
                    ),
                  ),
                  onTap: () {
                    log('########## TAP on $index');
                    getIt<SettingsBloc>().add(SettingsSaveDaysEvent(daysIndex: index));
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
