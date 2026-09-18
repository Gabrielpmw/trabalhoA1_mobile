import 'package:flutter/material.dart';

// ==============================================================================
// ITEM DO TRABALHO:
// "Os dados trafegados entre as telas devem ser estruturados em uma classe modelo
// (ex.: class Usuario ou class Produto), e não em múltiplas Strings soltas no construtor."
// ==============================================================================
class Tarefa {
  final String titulo;
  final String descricao;
  final String prioridade; // 'Baixa', 'Média', 'Alta'
  final bool concluida;

  const Tarefa({
    required this.titulo,
    required this.descricao,
    required this.prioridade,
    this.concluida = false,
  });
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ListaTarefasScreen(),
  ));
}

// ==============================================================================
// ITEM DO TRABALHO:
// "Fluxo com no mínimo três telas conectadas."
// TELA 1 (Lista de Tarefas):
// "Exibe as tarefas cadastradas (título, descrição, prioridade). Contém um botão
// para adicionar uma nova e um toque em um item para abrir os detalhes."
// ==============================================================================
class ListaTarefasScreen extends StatefulWidget {
  const ListaTarefasScreen({super.key});

  @override
  State<ListaTarefasScreen> createState() => _ListaTarefasScreenState();
}

class _ListaTarefasScreenState extends State<ListaTarefasScreen> {
  // Lista em memória com os dados iniciais
  final List<Tarefa> _tarefas = [
    const Tarefa(
      titulo: 'Estudar Flutter',
      descricao: 'Praticar navegação e envio de dados entre telas.',
      prioridade: 'Alta',
    ),
    const Tarefa(
      titulo: 'Fazer compras',
      descricao: 'Comprar frutas, leite e pão.',
      prioridade: 'Média',
    ),
  ];

  // ============================================================================
  // ITENS DO TRABALHO:
  // 1. "Abordar navegação entre telas utilizando Navigator.push"
  // 2. "O retorno deve ... ser tratado na tela chamadora com await Navigator.push(...),
  //     seguido de setState para refletir o dado devolvido."
  // 3. "Retorno de valores entre telas"
  // ============================================================================
  Future<void> _adicionarTarefa() async {
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

  // ============================================================================
  // ITENS DO TRABALHO:
  // 1. "Permitir o envio de dados de uma tela para outra"
  // 2. "Passagem de parâmetros pelo construtor, envio de objetos"
  // 3. "Tratado na tela chamadora com await Navigator.push(...), seguido de setState"
  // ============================================================================
  Future<void> _abrirDetalhes(int index) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: _tarefas.isEmpty
          ? const Center(child: Text('Nenhuma tarefa cadastrada.'))
          : ListView.builder(
              itemCount: _tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = _tarefas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Icon(
                      tarefa.concluida
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: tarefa.concluida ? Colors.green : Colors.grey,
                    ),
                    // Exibe título, prioridade e descrição da tarefa
                    title: Text(
                      tarefa.titulo,
                      style: TextStyle(
                        decoration: tarefa.concluida
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Text(
                      'Prioridade: ${tarefa.prioridade}\n${tarefa.descricao}',
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                    // ITEM: "Toque em um item para abrir os detalhes"
                    onTap: () => _abrirDetalhes(index),
                  ),
                );
              },
            ),
      // ITEM: "Contém um botão para adicionar uma nova"
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarTarefa,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ==============================================================================
// ITEM DO TRABALHO:
// "Fluxo com no mínimo três telas conectadas."
// TELA 2 (Detalhes da Tarefa):
// "Recebe o objeto Tarefa via construtor. Mostra as informações completas e
// tem um botão 'Editar' e outro 'Concluir/Excluir'."
// ==============================================================================
class DetalhesTarefaScreen extends StatefulWidget {
  // ITEM DO TRABALHO:
  // "Passagem de parâmetros pelo construtor, envio de objetos, recebimento de parâmetros"
  final Tarefa tarefa;

  const DetalhesTarefaScreen({super.key, required this.tarefa});

  @override
  State<DetalhesTarefaScreen> createState() => _DetalhesTarefaScreenState();
}

class _DetalhesTarefaScreenState extends State<DetalhesTarefaScreen> {
  late Tarefa _tarefa;

  @override
  void initState() {
    super.initState();
    // Recebimento do objeto passado via construtor
    _tarefa = widget.tarefa;
  }

  // ============================================================================
  // ITENS DO TRABALHO:
  // 1. "Botão Editar"
  // 2. "Envio de objetos de uma tela para outra (Tela 2 -> Tela 3)"
  // 3. "await Navigator.push(...), seguido de setState para refletir o dado devolvido."
  // ============================================================================
  Future<void> _editarTarefa() async {
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

  // ============================================================================
  // ITENS DO TRABALHO:
  // 1. "Botão Concluir/Excluir"
  // 2. "O retorno deve usar Navigator.pop(context, resultado) na tela secundária"
  // 3. "Retorno de valores entre telas"
  // ============================================================================
  void _concluirTarefa() {
    final tarefaAtualizada = Tarefa(
      titulo: _tarefa.titulo,
      descricao: _tarefa.descricao,
      prioridade: _tarefa.prioridade,
      concluida: !_tarefa.concluida,
    );
    // Retorno do objeto atualizado para a Tela 1 usando Navigator.pop
    Navigator.pop(context, tarefaAtualizada);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          // Garante o retorno do objeto caso o usuário volte pelo botão do Android
          Navigator.pop(context, _tarefa);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes da Tarefa'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            // ITEM: Retorno do objeto atualizado para a Tela 1 via Navigator.pop
            onPressed: () => Navigator.pop(context, _tarefa),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ITEM: "Mostra as informações completas"
              Text(
                _tarefa.titulo,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Prioridade: ${_tarefa.prioridade}',
                style: const TextStyle(color: Colors.blueGrey, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Status: ${_tarefa.concluida ? "Concluída" : "Pendente"}',
                style: TextStyle(
                  color: _tarefa.concluida ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Divider(height: 24),
              const Text(
                'Descrição:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                _tarefa.descricao.isEmpty
                    ? 'Sem descrição.'
                    : _tarefa.descricao,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),

              // ITEM: "tem um botão 'Editar' e outro 'Concluir/Excluir'"
              Row(
                children: [
                  // Botão Editar
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _editarTarefa,
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Botão Concluir
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _concluirTarefa,
                      icon: Icon(_tarefa.concluida ? Icons.undo : Icons.check),
                      label: Text(_tarefa.concluida ? 'Reabrir' : 'Concluir'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Botão Excluir (utiliza Navigator.pop com resultado para a Tela 1)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context, 'excluir'),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text('Excluir', style: TextStyle(color: Colors.red)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==============================================================================
// ITEM DO TRABALHO:
// "Fluxo com no mínimo três telas conectadas."
// TELA 3 (Formulário de Cadastro/Edição):
// "Formulário para alterar os campos da tarefa. Ao salvar, retorna o objeto
// Tarefa atualizado."
// ==============================================================================
class FormularioTarefaScreen extends StatefulWidget {
  // ITEM: Passagem e recebimento de parâmetros via construtor (objeto Tarefa)
  final Tarefa? tarefa; // Se for nulo é nova tarefa, se preenchido é edição

  const FormularioTarefaScreen({super.key, this.tarefa});

  @override
  State<FormularioTarefaScreen> createState() => _FormularioTarefaScreenState();
}

class _FormularioTarefaScreenState extends State<FormularioTarefaScreen> {
  late TextEditingController _tituloController;
  late TextEditingController _descricaoController;
  late String _prioridade;

  @override
  void initState() {
    super.initState();
    // Preenche os campos caso esteja recebendo uma tarefa para edição
    _tituloController = TextEditingController(text: widget.tarefa?.titulo ?? '');
    _descricaoController = TextEditingController(text: widget.tarefa?.descricao ?? '');
    _prioridade = widget.tarefa?.prioridade ?? 'Média';
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  // ============================================================================
  // ITENS DO TRABALHO:
  // 1. "Ao salvar, retorna o objeto Tarefa atualizado."
  // 2. "O retorno deve usar Navigator.pop(context, resultado) na tela secundária"
  // 3. "Retorno de valores entre telas"
  // ============================================================================
  void _salvar() {
    final titulo = _tituloController.text.trim();
    final descricao = _descricaoController.text.trim();

    if (titulo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O título é obrigatório.')),
      );
      return;
    }

    // Instanciação da classe modelo Tarefa
    final tarefaSalva = Tarefa(
      titulo: titulo,
      descricao: descricao,
      prioridade: _prioridade,
      concluida: widget.tarefa?.concluida ?? false,
    );

    // Retorno do objeto Tarefa atualizado usando Navigator.pop(context, resultado)
    Navigator.pop(context, tarefaSalva);
  }

  @override
  Widget build(BuildContext context) {
    final ehEdicao = widget.tarefa != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(ehEdicao ? 'Editar Tarefa' : 'Nova Tarefa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Formulário com os campos da tarefa
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _prioridade,
              decoration: const InputDecoration(
                labelText: 'Prioridade',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Baixa', child: Text('Baixa')),
                DropdownMenuItem(value: 'Média', child: Text('Média')),
                DropdownMenuItem(value: 'Alta', child: Text('Alta')),
              ],
              onChanged: (valor) {
                if (valor != null) {
                  setState(() => _prioridade = valor);
                }
              },
            ),
            const SizedBox(height: 24),
            // Botão Salvar (chama _salvar que executa o Navigator.pop)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _salvar,
                child: const Text('Salvar Tarefa', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
