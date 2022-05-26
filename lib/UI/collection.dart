import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/collection_provider.dart';

class CollectionList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CollectionListState();
}

class CollectionListState extends State<CollectionList> {
  _showMyDialog(BuildContext context) async {
		TextEditingController controller = TextEditingController();
    await showDialog<String>(
        context: context,
        builder: (BuildContext cnt) {
          return SimpleDialog(
						contentPadding:  const EdgeInsets.fromLTRB(16, 8, 16, 8),
            children: [
							TextField(
									decoration: const InputDecoration(
											border: InputBorder.none,
											hintText: "Title"
									),
									keyboardType: TextInputType.multiline,
									textInputAction: TextInputAction.done,
									controller: controller,
									onSubmitted: (String? string) {
										var collection = Provider.of<CollectionProvider>(context, listen: false);
										collection.insertcollection(controller.text);
									},
							),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CollectionProvider(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black87,
                )),
          ),
          body: SafeArea(
              child: Container(
            color: Colors.white,
						height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Consumer<CollectionProvider>(
                    builder: (context, collection, child) => ListView.builder(
                        padding: const EdgeInsets.all(16),
                        shrinkWrap: true,
                        itemCount: collection.collection.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 50,
                            child: Text(collection.collection[index].getText()),
                          );
                        }))),
          )),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showMyDialog(context),
            child: const Icon(Icons.add),
          ),
        ));
  }
}
