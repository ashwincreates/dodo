import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/collection_provider.dart';
import 'package:todo/UI/collection_page.dart';
import 'package:todo/util/db.dart';

class Collections extends StatelessWidget {
  const Collections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CollectionProvider(),
      builder: (context, widget) => const CollectionList(),
    );
  }
}

class CollectionList extends StatefulWidget {
  const CollectionList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CollectionListState();
}

class CollectionListState extends State<CollectionList> {
  bool isSelectedMode = false;

  _showMyDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    await showDialog<String>(
        context: context,
        builder: (BuildContext cnt) {
          return SimpleDialog(
            contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            children: [
              TextField(
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: "Title"),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                controller: controller,
                onSubmitted: (String? string) {
                  var collection =
                      Provider.of<CollectionProvider>(context, listen: false);
                  collection.insertcollection(controller.text);
                  controller.text = "";
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
  }

  onSelected(int index) {
    var collection = Provider.of<CollectionProvider>(context);
    collection.toggle(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: !isSelectedMode
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              titleSpacing: 0,
              title: const Text(
                "Collections",
                style: TextStyle(color: Colors.black87),
              ),
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 22,
                    color: Colors.black87,
                  )),
            )
          : AppBar(
              backgroundColor: Colors.blue,
              elevation: 0,
              leading: IconButton(
                  onPressed: () {
                    setState(() {
                      isSelectedMode = false;
                    });
                  },
                  icon: const Icon(Icons.close)),
              actions: [
                IconButton(
                    onPressed: () {
                      var collection = Provider.of<CollectionProvider>(context,
                          listen: false);
                      collection.deleteCollections();
                      setState(() {
                        isSelectedMode = false;
                      });
                    },
                    icon: const Icon(Icons.delete))
              ],
            ),
      body: SafeArea(
        child: Consumer<CollectionProvider>(
            builder: (context, collection, child) => GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                itemCount: collection.collection.length,
                itemBuilder: (BuildContext context, int index) {
                  var date = collection.collection[index].getDate;
                  return Container(
                      margin: EdgeInsets.fromLTRB((index % 2 == 0 ? 0 : 4), 0,
                          (index % 2 == 0 ? 4 : 0), 8),
                      child: InkWell(
                          onTap: () {
                            if (isSelectedMode) {
                              collection.toggle(index);
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CollectionPage(
                                          collection:
                                              collection.collection[index])
																			)
															).then((value) {
																collection.updateCollections(DB());
															});
                            }
                          },
                          onLongPress: () {
                            if (!isSelectedMode) {
                              collection.initSelection();
                              setState(() {
                                isSelectedMode = true;
                                collection.toggle(index);
                              });
                            }
                          },
                          child: GridTile(
                              child: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        collection.collection[index].getText,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "${date.day} ${DateFormat('MMM').format(date)} ${date.year}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      border: Border.all(
                                        color: isSelectedMode &&
                                                collection.selection[index]
                                            ? Colors.blue
                                            : Colors.black12,
                                        width: isSelectedMode &&
                                                collection.selection[index]
                                            ? 2
                                            : 1,
                                      ))))));
                })),
      ),
      floatingActionButton: !isSelectedMode
          ? FloatingActionButton(
              onPressed: () => _showMyDialog(context),
              child: const Icon(Icons.add),
            )
          : const SizedBox.shrink(),
    );
  }
}
