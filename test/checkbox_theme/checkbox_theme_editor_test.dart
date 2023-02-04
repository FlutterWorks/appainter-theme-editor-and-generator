import 'dart:math';

import 'package:appainter/checkbox_theme/checkbox_theme.dart';
import 'package:appainter/color_theme/color_theme.dart';
import 'package:appainter/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';
import '../utils.dart';
import '../utils/widget_tester_utils.dart';

void main() {
  const checkboxState = CheckboxThemeState();

  late CheckboxThemeCubit checkboxCubit;
  late ColorThemeCubit colorCubit;

  late Color color;
  late double doubleNum;
  late String doubleStr;

  setUp(() {
    checkboxCubit = MockCheckboxThemeCubit();
    colorCubit = MockColorThemeCubit();

    color = getRandomColor();
    doubleNum = Random().nextDouble();
    doubleStr = doubleNum.toString();

    when(() => colorCubit.state).thenReturn(ColorThemeState());
  });

  Future<void> pumpApp(WidgetTester tester, [CheckboxThemeState? state]) async {
    when(() => checkboxCubit.state).thenReturn(state ?? checkboxState);

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: checkboxCubit),
            BlocProvider.value(value: colorCubit),
          ],
          child: const Scaffold(
            body: CheckboxThemeEditor(),
          ),
        ),
      ),
    );
  }

  void expectBlocBuilder(
    WidgetTester tester,
    String key,
    CheckboxThemeState state,
  ) {
    tester.expectBlocBuilder<CheckboxThemeCubit, CheckboxThemeState>(
      key,
      checkboxState,
      state,
    );
  }

  group('fill colors', () {
    group('default color picker', () {
      const key = 'checkboxThemeEditor_fillColor_default';

      testWidgets('render widget', (tester) async {
        final prop = getMaterialStateProperty({null: color});
        final state = CheckboxThemeState.withTheme(fillColor: prop);

        await pumpApp(tester, state);

        await tester.expectColorIndicator(key, color);
      });

      testWidgets('change color', (tester) async {
        final opaqueColor = color.withOpacity(0.54);
        await pumpApp(tester);
        await tester.verifyColorPicker(
          key,
          opaqueColor,
          checkboxCubit.fillDefaultColorChanged,
        );
      });
    });

    group('selected color picker', () {
      const key = 'checkboxThemeEditor_fillColor_selected';

      testWidgets('render widget', (tester) async {
        final prop = getMaterialStateProperty({MaterialState.selected: color});
        final state = CheckboxThemeState.withTheme(fillColor: prop);

        await pumpApp(tester, state);

        await tester.expectColorIndicator(key, color);
      });

      testWidgets('change color', (tester) async {
        await pumpApp(tester);
        await tester.verifyColorPicker(
          key,
          color,
          checkboxCubit.fillSelectedColorChanged,
        );
      });
    });

    group('disabled color picker', () {
      const key = 'checkboxThemeEditor_fillColor_disabled';

      testWidgets('render widget', (tester) async {
        final prop = getMaterialStateProperty({MaterialState.disabled: color});
        final state = CheckboxThemeState.withTheme(fillColor: prop);

        await pumpApp(tester, state);

        await tester.expectColorIndicator(key, color);
      });

      testWidgets('change color', (tester) async {
        final opaqueColor = color.withOpacity(0.38);
        await pumpApp(tester);
        await tester.verifyColorPicker(
          key,
          opaqueColor,
          checkboxCubit.fillDisabledColorChanged,
        );
      });
    });
  });

  group('check color picker', () {
    const key = 'checkboxThemeEditor_checkColor_default';

    testWidgets('render widget', (tester) async {
      final prop = getMaterialStateProperty({null: color});
      final state = CheckboxThemeState.withTheme(checkColor: prop);

      await pumpApp(tester, state);

      await tester.expectColorIndicator(key, color);
    });

    testWidgets('change color', (tester) async {
      await pumpApp(tester);
      await tester.verifyColorPicker(
        key,
        color,
        checkboxCubit.checkColorChanged,
      );
    });
  });

  group('overlay colors', () {
    group('pressed color picker', () {
      const key = 'checkboxThemeEditor_overlayColor_pressed';

      testWidgets('render widget', (tester) async {
        final prop = getMaterialStateProperty({MaterialState.pressed: color});
        final state = CheckboxThemeState.withTheme(overlayColor: prop);

        await pumpApp(tester, state);

        await tester.expectColorIndicator(key, color);
      });

      testWidgets('change color', (tester) async {
        final opaqueColor = color.withOpacity(0.12);
        await pumpApp(tester);
        await tester.verifyColorPicker(
          key,
          opaqueColor,
          checkboxCubit.overlayPressedColorChanged,
        );
      });
    });

    group('hovered color picker', () {
      const key = 'checkboxThemeEditor_overlayColor_hovered';

      testWidgets('render widget', (tester) async {
        final prop = getMaterialStateProperty({MaterialState.hovered: color});
        final state = CheckboxThemeState.withTheme(overlayColor: prop);

        await pumpApp(tester, state);

        await tester.expectColorIndicator(key, color);
      });

      testWidgets('change color', (tester) async {
        final opaqueColor = color.withOpacity(0.04);
        await pumpApp(tester);
        await tester.verifyColorPicker(
          key,
          opaqueColor,
          checkboxCubit.overlayHoveredColorChanged,
        );
      });
    });

    group('focused color picker', () {
      const key = 'checkboxThemeEditor_overlayColor_focused';

      testWidgets('render widget', (tester) async {
        final prop = getMaterialStateProperty({MaterialState.focused: color});
        final state = CheckboxThemeState.withTheme(overlayColor: prop);

        await pumpApp(tester, state);

        await tester.expectColorIndicator(key, color);
      });

      testWidgets('change color', (tester) async {
        final opaqueColor = color.withOpacity(0.12);
        await pumpApp(tester);
        await tester.verifyColorPicker(
          key,
          opaqueColor,
          checkboxCubit.overlayFocusedColorChanged,
        );
      });
    });
  });

  group('splash radius text field', () {
    const key = 'checkboxThemeEditor_splashRadiusTextField';

    testWidgets('render widget', (tester) async {
      final state = CheckboxThemeState.withTheme(splashRadius: doubleNum);

      await pumpApp(tester, state);

      await tester.expectTextField(key, doubleStr);
      expectBlocBuilder(tester, key, state);
    });

    testWidgets('change text', (tester) async {
      await pumpApp(tester);
      await tester.verifyTextField(
        key,
        doubleStr,
        checkboxCubit.splashRadiusChanged,
      );
    });
  });

  group('material tap target size dropdown', () {
    const key = 'checkboxThemeEditor_materialTapTargetSizeDropdown';

    for (var size in MaterialTapTargetSize.values) {
      final sizeStr = UtilService.enumToString(size);

      testWidgets('render $size', (tester) async {
        final state = CheckboxThemeState.withTheme(materialTapTargetSize: size);

        await pumpApp(tester, state);

        await tester.expectDropdown(key, sizeStr);
        expectBlocBuilder(tester, key, state);
      });

      testWidgets('change $size', (tester) async {
        await pumpApp(tester);
        await tester.verifyDropdown(
          key,
          sizeStr,
          checkboxCubit.materialTapTargetSize,
        );
      });
    }
  });
}
