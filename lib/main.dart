import 'package:flutter/material.dart';
import 'package:test/remote.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Card',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.red,
        ),
        home: const MyHomePage(title: "Card game"));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String amount = "0";
  String deckCount = "0";
  List cards = [];

  TextEditingController group = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder(
            future: drawCards(group: group.text.toString(), amount: amount),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: SizedBox(child: CircularProgressIndicator()));
              } else if (snapshot.data["success"] == false) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "ใส่ ID Deck card",
                          style: TextStyle(fontSize: 16),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 250,
                            child: TextField(
                              controller: group,
                              onSubmitted: (value) async {
                                final data = await drawCards(group: value, amount: amount);
                                cards.addAll(data["cards"]);
                                setState(() {
                                  deckCount = data["remaining"].toString();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              final item = snapshot.data as Map<String, dynamic>;
              cards.addAll(item["cards"] as List);

              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.center,
                        width: double.maxFinite,
                        child: Text(
                          "การ์ดคงเหลือในสำรับ .... $deckCount ใบ",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Container(
                        width: 250,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: group,
                            onSubmitted: (value) => drawCards(group: value, amount: amount),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: cards.isEmpty
                          ? FilledButton(
                              onPressed: () async {
                                final data = await drawCards(group: group.text.toString(), amount: "2");
                                cards.addAll(data["cards"]);
                                setState(() {
                                  deckCount = data["remaining"].toString();
                                });
                              },
                              child: const Text(
                                "จั่วการ์ด",
                                style: TextStyle(fontSize: 16),
                              ))
                          : const SizedBox.shrink(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: SizedBox(
                        height: 350,
                        child: cards.isEmpty
                            ? const SizedBox.shrink()
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    for (final card in cards)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              width: 220,
                                              height: 300,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(12),
                                                  image: DecorationImage(
                                                    image: NetworkImage(card["image"]),
                                                    fit: BoxFit.contain,
                                                  )),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 15.0),
                                              child: Text(card['value']),
                                            ),
                                          ],
                                        ),
                                      ),
                                    cards.length < 3
                                        ? TextButton(
                                            onPressed: () async {
                                              final data = await drawCards(group: group.text.toString(), amount: "1");
                                              cards.addAll(data["cards"]);
                                              setState(() {
                                                deckCount = data["remaining"].toString();
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                              child: Container(
                                                width: 200,
                                                height: 300,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(color: Colors.black),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: const Icon(Icons.exposure_plus_1_rounded),
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    cards.isNotEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "card  ที่คุณได้คือ ",
                                style: TextStyle(fontSize: 16),
                              ),
                              for (final card in cards)
                                Text(
                                  "${card["value"]}, ",
                                  style: const TextStyle(fontSize: 16),
                                ),
                            ],
                          )
                        : const Padding(
                            padding: EdgeInsets.only(bottom: 20.0),
                            child: Text(
                              "รอจั่วการ์ด....",
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
