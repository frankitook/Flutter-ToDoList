import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MiApp());

class MiApp extends StatelessWidget {
  const MiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Tasks",
      home: Inicio(),
    );
  }
}

class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  List<Tarea> tareas = [];
  final TextEditingController _nuevaTareaController = TextEditingController();
  bool mostrarTextField = false;

  @override
  void initState() {
    super.initState();
    _cargarTareas();
  }

  Future<void> _cargarTareas() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? tareasGuardadas = prefs.getStringList('tareas');
    if (tareasGuardadas != null) {
      setState(() {
        tareas = tareasGuardadas
            .map((tarea) =>
                Tarea.fromMap(Map<String, dynamic>.from({'tarea': tarea})))
            .toList();
      });
    }
  }

  Future<void> _guardarTareas() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> tareasString =
        tareas.map((tarea) => tarea.toMap().toString()).toList();
    prefs.setStringList('tareas', tareasString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(""),
        centerTitle: true,
        backgroundColor: const Color(0xFFDFB09E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            print('Botón de menú presionado');
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          color: const Color(0xFFDFB09E),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                child: Image.network(
                  "https://i.pinimg.com/736x/76/fb/91/76fb918ef91f1a4e5c3df3a8948ab50e.jpg",
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                flex: 7,
                child: SafeArea(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Tareas:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount:
                                tareas.length + (mostrarTextField ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (mostrarTextField && index == tareas.length) {
                                return ListTile(
                                  title: Row(
                                    children: [
                                      const Checkbox(
                                        value: false,
                                        onChanged: null,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: _nuevaTareaController,
                                          decoration: const InputDecoration(
                                            hintText: 'Nueva tarea',
                                          ),
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          onSubmitted: (texto) {
                                            _agregarTarea(texto);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return ListTile(
                                  title: Row(
                                    children: [
                                      Checkbox(
                                        value: tareas[index].completada,
                                        onChanged: (value) {
                                          setState(() {
                                            tareas[index].completada = value!;
                                          });
                                          _guardarTareas();
                                        },
                                      ),
                                      Expanded(
                                        child: Text(
                                          tareas[index].texto,
                                          style: TextStyle(
                                            decoration: tareas[index].completada
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          _eliminarTarea(index);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            mostrarTextField = !mostrarTextField;
          });
        },
        backgroundColor: const Color.fromARGB(255, 172, 146, 202),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _agregarTarea(String texto) {
    setState(() {
      tareas.add(Tarea(texto: texto, completada: false));
      mostrarTextField = false;
      _nuevaTareaController.clear();
      _guardarTareas();
    });
  }

  void _eliminarTarea(int index) {
    setState(() {
      tareas.removeAt(index);
      _guardarTareas();
    });
  }
}

class Tarea {
  String texto;
  bool completada;

  Tarea({required this.texto, required this.completada});

  Map<String, dynamic> toMap() {
    return {
      'texto': texto,
      'completada': completada,
    };
  }

  factory Tarea.fromMap(Map<String, dynamic> map) {
    return Tarea(
      texto: map['texto'] as String,
      completada: map['completada'] as bool,
    );
  }
}
