import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  final String txt, acronym, desc;
  final IconData icon;
  final ValueChanged<String> input;

  const InputBox({
    super.key,
    required this.txt,
    required this.icon,
    required this.acronym,
    required this.input,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$txt ${(acronym.isNotEmpty) ? "($acronym)" : ""}",
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                      hoverColor: Theme.of(context).highlightColor,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) { return AlertDialog(
                            title: Text(txt),
                            content: Text(desc),
                            actions: [
                              TextButton(onPressed: () {
                                Navigator.of(context).pop();
                              }, child: const Text("OK"))
                            ],
                          );}
                        );
                      },
                      icon: const Icon(Icons.info_outline_rounded)),
                ],
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    icon: Icon(icon),
                    hintText: "Enter your ${txt.toLowerCase()}."),
                onChanged: input,
              )
            ],
          ),
        ),
      ),
    );
  }
}
