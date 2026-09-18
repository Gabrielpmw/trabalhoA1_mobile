import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trabalho_a1/main.dart';

void main() {
  testWidgets('Carrega Lista de Tarefas e navega para detalhes', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: ListaTarefasScreen(),
    ));

    // Verifica se a tela inicial exibe os títulos das tarefas iniciais
    expect(find.text('Minhas Tarefas'), findsOneWidget);
    expect(find.text('Estudar Flutter'), findsOneWidget);

    // Clica na tarefa para abrir os detalhes
    await tester.tap(find.text('Estudar Flutter'));
    await tester.pumpAndSettle();

    // Verifica se a Tela de Detalhes abriu
    expect(find.text('Detalhes da Tarefa'), findsOneWidget);
    expect(find.text('Editar'), findsOneWidget);
    expect(find.text('Concluir'), findsOneWidget);
    expect(find.text('Excluir'), findsOneWidget);
  });
}
