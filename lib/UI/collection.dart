import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/collection_provider.dart';

class Collections extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return ChangeNotifierProvider(
				create: (context) => CollectionProvider(),
				builder: (context, widget) => CollectionList(),
		);
  }
}

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
										builder: (context, collection, child) => GridView.builder(
												gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                        padding: const EdgeInsets.all(16),
                        shrinkWrap: true,
                        itemCount: collection.collection.length,
                        itemBuilder: (BuildContext context, int index) {
													var date = collection.collection[index].getDate;
                          return Container(
														margin: EdgeInsets.only(bottom: 8, left: index % 2 == 0 ? 0 : 4, right: index % 2 == 0? 4 : 0),
														padding: EdgeInsets.all(12),
														child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																		Text(
																				collection.collection[index].getText, 
																				style: const TextStyle(
																						fontSize: 18,
																						fontWeight: FontWeight.w600
																					),
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
																borderRadius: const BorderRadius.all(Radius.circular(8)),
																border: Border.all(color: Colors.black12)));
                        }))),
          )),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showMyDialog(context),
            child: const Icon(Icons.add),
          ),
        );
  }
}
