import 'package:flutter/cupertino.dart';
import 'package:svg_path_parser/svg_path_parser.dart';

const _cinemaSeatSvg =
    'm6.752 25.404-6.8 3.4.6 50.2.6 5.4.8 3 1.4 4.2 3.4 4 4.8 2.6 34 1v-10.6h-29.8l-4.2-2.2-3-4-1.8-5v-52zm78.4 0 6.8 3.4-.6 50.2-.6 5.4-.8 3-1.4 4.2-3.4 4-4.8 2.6-34 1v-10.6h29.8l4.2-2.2 3-4 1.8-5v-52zm-11.512-24.656c4.256 0 7.712 3.456 7.712 7.712 0 15.016 0 52.36 0 67.376 0 4.256-3.456 7.712-7.712 7.712-12.464 0-42.12 0-54.584 0-4.256 0-7.704-3.456-7.704-7.712 0-15.016 0-52.36 0-67.376 0-4.256 3.448-7.712 7.704-7.712 12.464 0 42.12 0 54.584 0z';

var _ = parseSvgPath(_cinemaSeatSvg).getBounds().size;

var cinemaSeat = parseSvgPath(_cinemaSeatSvg).transform(
    (Matrix4.identity()..scale(24 / _.width, 24 / _.height)).storage);
