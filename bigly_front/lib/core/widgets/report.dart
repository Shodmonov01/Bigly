
import 'package:flutter/material.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/extensions/widget_extension.dart';

class Report extends StatelessWidget {
  const Report({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: .7.hp(context),
      child: Column(
        children: [
          const Text(
            'Report',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                const Divider(),
                const Text(
                  'Why are vou renortina this nost?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ).padding(const EdgeInsets.all(10)),
                const Text(
                  "Your report is anonymous, except if you're reporting an intellectual property infringement. If someone is in immediate danger, call the local emergency services -",
                  style: TextStyle(
                    color: Colors.grey
                  ),
                ).padding(const EdgeInsets.all(10)),
                const Divider(),

                Column(
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: [
                      ListTile(
                        onTap: (){},
                        title: const Text("I just don't like it"),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      ListTile(
                        onTap: (){},
                        title: const Text("It's spam"),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      ListTile(
                        onTap: (){},
                        title: const Text("Nuditv or sexual activity"),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      ListTile(
                        onTap: (){},
                        title: const Text("Hate speech or symbols"),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      ListTile(
                        onTap: (){},
                        title: const Text("Violence or dangerous organizations"),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      ListTile(
                        onTap: (){},
                        title: const Text("Bullying or harassment"),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      ListTile(
                        onTap: (){},
                        title: const Text("False information"),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      ListTile(
                        onTap: (){},
                        title: const Text("Scam or fraud"),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      ListTile(
                        onTap: (){},
                        title: const Text("Suicide or self-injury"),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      ListTile(
                        onTap: (){},
                        title: const Text("Sale of illegal or regulated goods"),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      ListTile(
                        onTap: (){},
                        title: const Text("Intellectual property violation"),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      ListTile(
                        onTap: (){},
                        title: const Text("Eating disorders"),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      ListTile(
                        onTap: (){},
                        title: const Text("Drugs"),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      ListTile(
                        onTap: (){},
                        title: const Text("Something else"),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    ]
                  ).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


