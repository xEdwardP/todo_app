import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Task> _tasks = [];
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _dialogController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  // void _addTask() {
  //   if (_inputController.text.isNotEmpty) {
  //     setState(() {
  //       _tasks.add(Task(_inputController.text, _descriptionController.text));
  //       _inputController.clear();
  //     });
  //   }
  // }

  // void _removeTask(int index) {
  //   setState(() {
  //     _tasks.removeAt(index);
  //   });
  // }

  void _confirmDeleteTask(index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 5),
            const Text(
              "Confirmar eliminación",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "¿Estás seguro de que deseas eliminar esta tarea? Esta acción no se puede deshacer.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancelar"),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.delete),
            label: const Text("Eliminar"),
            onPressed: () {
              setState(() {
                _tasks.removeAt(index);
              });
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("¡Tarea eliminada con éxito!"),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showTask(int index) {
    final task = _tasks[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.visibility, color: Colors.blue),
            SizedBox(width: 5),
            const Text(
              "Detalles de la tarea",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Titulo:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 2.5),
            Text(task.title),

            const SizedBox(height: 5),
            Text("Descripción:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 2.5),
            Text(task.description),

            const SizedBox(height: 5),
            Text('Fecha:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 2.5),
            Text(task.date!.toLocal().toString().split(' ')[0]),

            const SizedBox(height: 5),
            Text('Estado:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 2.5),
            Text(
              task.done ? "Completada" : "Pendiente",
              style: TextStyle(color: task.done ? Colors.green : Colors.red),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cerrar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _toggleTask(int index, bool? value) {
    setState(() {
      _tasks[index].done = value ?? false;
    });
  }

  void _editTask(int index) {
    _dialogController.text = _tasks[index].title;
    _descriptionController.text = _tasks[index].description;
    _selectedDate = _tasks[index].date!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.edit, color: Colors.orange),
            SizedBox(width: 5),
            const Text(
              "Editar tarea",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Titulo:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 2.5),
            TextField(
              controller: _dialogController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Título de la tarea...",
              ),
            ),
            const SizedBox(height: 10),

            Text("Descripción:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 2.5),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: "Descripción de la tarea...",
              ),
            ),
            const SizedBox(height: 10),
            Text("Fecha:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 2.5),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Fecha: ${_selectedDate.toLocal().toString().split(' ')[0]}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _dialogController.clear();
              _descriptionController.clear();
              _selectedDate = DateTime.now();
            },
            child: const Text("Cancelar"),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.save),
            label: const Text("Guardar"),
            onPressed: () {
              if (_dialogController.text.isNotEmpty &&
                  _descriptionController.text.isNotEmpty) {
                setState(() {
                  _tasks[index].title = _dialogController.text;
                  _tasks[index].description = _descriptionController.text;
                  _tasks[index].date = _selectedDate;
                });
                _dialogController.clear();
                _descriptionController.clear();
                _selectedDate = DateTime.now();
                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("¡Tarea actualizada con éxito!"),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int pendingTasks = _tasks.where((t) => !t.done).length;

    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Tareas ($pendingTasks pendientes)"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _tasks.isEmpty
                ? const Center(child: Text("No hay tareas agregadas !"))
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: _tasks[index].done,
                            onChanged: (value) => _toggleTask(index, value),
                          ),
                          title: Text(
                            _tasks[index].title,
                            style: TextStyle(
                              decoration: _tasks[index].done
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          onTap: () => _editTask(index),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Show Button
                              IconButton(
                                icon: const Icon(
                                  Icons.visibility,
                                  color: Colors.blue,
                                ),
                                onPressed: () => _showTask(index),
                              ),
                              // Delete Button
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _confirmDeleteTask(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        tooltip: 'Agregar tarea',
        onPressed: () {
          _dialogController.clear();
          _descriptionController.clear();
          // _selectedDate = DateTime.now();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.add, color: Colors.green),
                  SizedBox(width: 5),
                  const Text(
                    "Nueva Tarea",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Task Name
                  TextField(
                    controller: _dialogController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: "Escribe una tarea...",
                    ),
                  ),
                  SizedBox(height: 10.0),
                  // Task Description
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      hintText: "Escribe una descripción...",
                    ),
                  ),
                  SizedBox(height: 10.0),
                  // Task Date
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Fecha: ${_selectedDate.toLocal().toString().split(' ')[0]}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              _selectedDate = picked;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _dialogController.clear();
                    _descriptionController.clear();
                    _selectedDate = DateTime.now();
                  },
                  child: const Text("Cancelar"),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text("Agregar"),
                  onPressed: () {
                    if (_dialogController.text.isNotEmpty &&
                        _descriptionController.text.isNotEmpty) {
                      setState(() {
                        _tasks.add(
                          Task(
                            _dialogController.text,
                            _descriptionController.text,
                            _selectedDate,
                          ),
                        );
                      });
                      _dialogController.clear();
                      _descriptionController.clear();
                      _selectedDate = DateTime.now();
                      Navigator.of(context).pop();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("¡Tarea agregada con éxito!"),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    _dialogController.dispose();
    _descriptionController.dispose();
    _selectedDate = DateTime.now();
    super.dispose();
  }
}
