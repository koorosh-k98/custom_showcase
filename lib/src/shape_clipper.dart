/*
 * Copyright (c) 2024
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class RRectClipper extends CustomClipper<ui.Path> {
  final bool isCircle;
  final BorderRadius? radius;
  final EdgeInsets overlayPadding;
  final Rect area;

  RRectClipper({
    this.isCircle = false,
    this.radius,
    this.overlayPadding = EdgeInsets.zero,
    this.area = Rect.zero,
  });

  @override
  ui.Path getClip(ui.Size size) {
    final customRadius =
        isCircle ? Radius.circular(area.height) : const Radius.circular(3.0);

    final rect = Rect.fromLTRB(
      area.left - overlayPadding.left,
      area.top - overlayPadding.top,
      area.right + overlayPadding.right,
      area.bottom + overlayPadding.bottom,
    );

    return Path()
      ..fillType = ui.PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addRRect(
        RRect.fromRectAndCorners(
          rect,
          topLeft: (radius?.topLeft ?? customRadius),
          topRight: (radius?.topRight ?? customRadius),
          bottomLeft: (radius?.bottomLeft ?? customRadius),
          bottomRight: (radius?.bottomRight ?? customRadius),
        ),
      );
  }

  @override
  bool shouldReclip(covariant RRectClipper oldClipper) =>
      isCircle != oldClipper.isCircle ||
      radius != oldClipper.radius ||
      overlayPadding != oldClipper.overlayPadding ||
      area != oldClipper.area;
}

class CustomRRectClipper extends CustomClipper<ui.Path> {
  final double radius;
  final EdgeInsets overlayPadding;
  final Rect area;
  final bool isTop;

  CustomRRectClipper({
    this.radius = 20,
    this.overlayPadding = EdgeInsets.zero,
    this.area = Rect.zero,
    this.isTop = true,
  });

  @override
  ui.Path getClip(ui.Size size) {
    Path topPath = Path()
      ..fillType = ui.PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..lineTo(0.0, area.size.height - radius)
      ..quadraticBezierTo(0.0, area.size.height, radius, area.size.height)
      ..lineTo(area.size.width - radius, area.size.height)
      ..quadraticBezierTo(area.size.width, area.size.height, area.size.width,
          area.size.height - radius)
      ..lineTo(area.size.width, radius)
      ..quadraticBezierTo(area.size.width, 0.0, area.size.width - radius, 0.0)
      ..lineTo(radius, 0.0)
      ..quadraticBezierTo(0.0, 0.0, 0.0, radius);

    Path bottomPath = Path()
      ..fillType = ui.PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..lineTo(0.0, area.size.height - radius)
      ..quadraticBezierTo(0.0, area.size.height, radius, area.size.height)
      ..lineTo(area.size.width - radius, area.size.height)
      ..quadraticBezierTo(area.size.width, area.size.height, area.size.width,
          area.size.height - radius)
      ..lineTo(area.size.width, radius)
      ..quadraticBezierTo(area.size.width, 0.0, area.size.width - radius, 0.0)
      ..lineTo(0.0, 0.0)
      ..quadraticBezierTo(0.0, 0.0, 0.0, radius);

    return isTop ? topPath : bottomPath;
  }

  @override
  bool shouldReclip(covariant CustomRRectClipper oldClipper) =>
      isTop != oldClipper.isTop ||
      radius != oldClipper.radius ||
      overlayPadding != oldClipper.overlayPadding ||
      area != oldClipper.area;
}
