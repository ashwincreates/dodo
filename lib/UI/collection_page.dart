import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/UI/tile.dart';
import 'package:todo/models/collection.dart';
import 'package:todo/models/collectionpage_provider.dart';

class CollectionPage extends StatelessWidget {
	final Collection collection;
	const CollectionPage({Key? key, required this.collection}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return ChangeNotifierProvider(
				create: (context) => CollectionPageProvider(collection: collection),
				builder: (context, widget) => Collections(collection: collection),
		);
  }
}

class Collections extends StatefulWidget {
	final Collection collection;
	const Collections({Key? key, required this.collection}) : super(key: key);

	@override
	State<StatefulWidget> createState() => CollectionsState(); 
}

class CollectionsState extends State<Collections> {

	TextEditingController controller = TextEditingController();

	@override
  void initState() {
		controller.text = widget.collection.text;
    super.initState();
  }

	@override
  Widget build(BuildContext context) {
		return Scaffold(
				backgroundColor: Colors.white,
				appBar: AppBar(
						elevation: 0,
						backgroundColor: Colors.white,
						leading: IconButton(onPressed: () => {Navigator.pop(context)}, icon: const Icon(Icons.arrow_back), color: Colors.black87, splashRadius: 25,),
				),
				body: SafeArea(
						child: Padding(
								padding: const EdgeInsets.symmetric(horizontal: 16),
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										TextField(
												controller: controller,
												decoration: const InputDecoration(
														border: InputBorder.none,
												),
												keyboardType: TextInputType.multiline,
												textInputAction: TextInputAction.done,
												onSubmitted : (String? string) {
													var page = Provider.of<CollectionPageProvider>(context, listen: false);
													page.updateCollection(controller.text);
												},
												style: const TextStyle(
																	 fontSize: 28,
																	 color: Colors.black87,
															 ),
										),
										Text("${widget.collection.date.day} ${DateFormat('MMM').format(widget.collection.date)} ${widget.collection.date.year}", 
												style: const TextStyle(
														color: Colors.grey,
														fontSize: 16,
												),
										),
										const SizedBox(
												height: 32,
										),
										Expanded(
												child: Consumer<CollectionPageProvider>(
													builder: (context, page, child) {
														return ListView.builder(
																itemCount: page.list.length,
																itemBuilder: (context, index) {
																	return Tile(
																			controller: page.controllers[index],
																			todo: page.list[index],
																			index: index,
																			onDelete: page.deleteElement,
																			onSubmit: page.save,
																			onUpdate: page.updateTodo,
																	);
																},
														);
													},
											)
										)
									],
								),
						) 
			 	),
				floatingActionButton: FloatingActionButton(
						onPressed: () {
							var page = context.read<CollectionPageProvider>();
							page.addItem();
						},
						child: const Icon(Icons.add),
				),
			);
  	}
}
