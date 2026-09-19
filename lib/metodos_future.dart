// MÉTODOS PARA O JOGUINHO DE IDENTIDADE
// Descubra qual código pertence a qual passo (1, 2 ou 3) no arquivo main.dart!

// =======================================================
// BLOCO DE CÓDIGO A
// =======================================================
  Future<void> __________________() async {
    final tarefaAtualizada = await Navigator.push<Tarefa>(
      context,
      MaterialPageRoute(
        // Envio do objeto Tarefa via construtor para o Formulário de Edição
        builder: (context) => FormularioTarefaScreen(tarefa: _tarefa),
      ),
    );

    // setState para refletir a alteração feita no formulário
    if (tarefaAtualizada != null) {
      setState(() {
        _tarefa = tarefaAtualizada;
      });
    }
  }

// =======================================================
// BLOCO DE CÓDIGO B
// =======================================================
  Future<void> __________________() async {
    // Navegação para Tela 3 aguardando o retorno do objeto criado
    final novaTarefa = await Navigator.push<Tarefa>(
      context,
      MaterialPageRoute(builder: (context) => const FormularioTarefaScreen()),
    );

    // setState para refletir o dado devolvido
    if (novaTarefa != null) {
      setState(() {
        _tarefas.add(novaTarefa);
      });
    }
  }

// =======================================================
// BLOCO DE CÓDIGO C
// =======================================================
  Future<void> __________________(int index) async {
    // Envio do objeto Tarefa pelo construtor para a Tela 2 e aguardo do resultado
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        // Passagem de parâmetro pelo construtor enviando o objeto Tarefa
        builder: (context) => DetalhesTarefaScreen(tarefa: _tarefas[index]),
      ),
    );

    // setState para refletir a alteração ou exclusão devolvida
    if (resultado is Tarefa) {
      setState(() {
        _tarefas[index] = resultado;
      });
    } else if (resultado == 'excluir') {
      setState(() {
        _tarefas.removeAt(index);
      });
    }
  }
