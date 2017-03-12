// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_ast/angular_ast.dart';

/// Provides a human-readable view of a template AST tree.
class HumanizingTemplateAstVisitor
    extends TemplateAstVisitor<String, StringBuffer> {
  const HumanizingTemplateAstVisitor();

  @override
  String visitAttribute(AttributeAst astNode, [_]) {
    if (astNode.value != null) {
      return '${astNode.name}="${astNode.value}"';
    } else {
      return '${astNode.name}';
    }
  }

  @override
  String visitBanana(BananaAst astNode, [_]) {
    String name = '[(${astNode.name})]';
    if (astNode.value != null) {
      return '$name="${astNode.value}"';
    } else {
      return name;
    }
  }

  @override
  String visitCloseElement(CloseElementAst astNode, [StringBuffer context]) {
    context ??= new StringBuffer();
    context..write('</')..write(astNode.name);
    if (astNode.whitespaces.isNotEmpty) {
      context..writeAll(astNode.whitespaces.map(visitWhitespace), ' ');
    }
    context.write('>');
    return context.toString();
  }

  @override
  String visitComment(CommentAst astNode, [_]) {
    return '<!--${astNode.value}-->';
  }

  @override
  String visitElement(ElementAst astNode, [StringBuffer context]) {
    context ??= new StringBuffer();
    context..write('<')..write(astNode.name);
    if (astNode.attributes.isNotEmpty) {
      context
        ..write(' ')
        ..writeAll(astNode.attributes.map(visitAttribute), ' ');
    }
    if (astNode.events.isNotEmpty) {
      context
        ..write(' ')
        ..writeAll(astNode.events.map(visitEvent), ' ');
    }
    if (astNode.properties.isNotEmpty) {
      context
        ..write(' ')
        ..writeAll(astNode.properties.map(visitProperty), ' ');
    }
    if (astNode.references.isNotEmpty) {
      context
        ..write(' ')
        ..writeAll(astNode.references.map(visitReference), ' ');
    }
    if (astNode.bananas.isNotEmpty) {
      context
        ..write(' ')
        ..writeAll(astNode.bananas.map(visitBanana), ' ');
    }
    if (astNode.stars.isNotEmpty) {
      context
        ..write(' ')
        ..writeAll(astNode.stars.map(visitStar), ' ');
    }
    if (astNode.whitespaces.isNotEmpty) {
      context..writeAll(astNode.whitespaces.map(visitWhitespace), ' ');
    }

    if (astNode.isSynthetic) {
      context.write(astNode.isVoidElement ? '/>' : '>');
    } else {
      context.write(astNode.endToken.lexeme);
    }

    if (astNode.childNodes.isNotEmpty) {
      context.writeAll(astNode.childNodes.map((c) => c.accept(this)));
    }
    if (astNode.closeComplement != null) {
      context.write(visitCloseElement(astNode.closeComplement));
    }
    return context.toString();
  }

  @override
  String visitEmbeddedContent(
    EmbeddedContentAst astNode, [
    StringBuffer context,
  ]) {
    context ??= new StringBuffer();
    if (astNode.selector != null) {
      context.write('<ng-content select="${astNode.selector}">');
    } else {
      context.write('<ng-content>');
    }
    context.write('</ng-content>');
    return context.toString();
  }

  @override
  String visitEmbeddedTemplate(
    EmbeddedTemplateAst astNode, [
    StringBuffer context,
  ]) {
    context ??= new StringBuffer();
    context..write('<template');
    if (astNode.attributes.isNotEmpty) {
      context
        ..write(' ')
        ..writeAll(astNode.attributes.map(visitAttribute), ' ');
    }
    if (astNode.properties.isNotEmpty) {
      context
        ..write(' ')
        ..writeAll(astNode.properties.map(visitProperty), ' ');
    }
    if (astNode.references.isNotEmpty) {
      context
        ..write(' ')
        ..writeAll(astNode.references.map(visitReference), ' ');
    }
    context.write('>');
    if (astNode.childNodes.isNotEmpty) {
      context.writeAll(astNode.childNodes.map((c) => c.accept(this)));
    }
    context..write('</template>');
    return context.toString();
  }

  @override
  String visitEvent(EventAst astNode, [_]) {
    String name = '(${astNode.name})';
    if (astNode.value != null) {
      return '$name="${astNode.value}"';
    } else {
      return name;
    }
  }

  @override
  String visitExpression(ExpressionAst astNode, [_]) {
    return astNode.expression.toSource();
  }

  @override
  String visitInterpolation(InterpolationAst astNode, [_]) {
    return '{{${astNode.value}}}';
  }

  @override
  String visitProperty(PropertyAst astNode, [_]) {
    String name = '[${astNode.name}]';
    if (astNode.value != null) {
      return '$name="${astNode.value}"';
    } else {
      return name;
    }
  }

  @override
  String visitReference(ReferenceAst astNode, [_]) {
    String identifier = '#${astNode.identifier}';
    if (astNode.variable != null) {
      return '$identifier="${astNode.variable}"';
    } else {
      return identifier;
    }
  }

  @override
  String visitStar(StarAst astNode, [_]) {
    String name = '${astNode.name}';
    if (astNode.value != null) {
      return 'name="${astNode.value}"';
    } else {
      return name;
    }
  }

  @override
  String visitText(TextAst astNode, [_]) => astNode.value;

  @override
  String visitWhitespace(WhitespaceAst astNode, [_]) => astNode.value;
}
