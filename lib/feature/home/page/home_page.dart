import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:irrigation/feature/home/widget/map_widget.dart';
import 'package:irrigation/feature/home/widget/sensor_delete_dialog.dart';
import 'package:irrigation/feature/home/widget/valve_list_item_widget.dart';
import 'package:irrigation/feature/sensor_add/page/sensor_add_page.dart';
import 'package:irrigation/feature/sensor_detail/page/sensor_detail_page.dart';
import 'package:irrigation/feature/widget/no_internet_widget.dart';
import 'package:irrigation/models/response/sensor_response.dart';
import 'package:irrigation/provider/network_provider.dart';
import 'package:irrigation/provider/sensor_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<SensorResponse> sensorResponses = List.empty();

  bool networkStatus = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      /* networkStatus =
          Provider.of<NetworkProvider>(context, listen: false).networkStatus;
      if (networkStatus) {
        Provider.of<SensorProvider>(context, listen: false).initializeList();
      }
*/
    });
  }

  Future<void> deleteSensorDialog(BuildContext context, SensorResponse sensor) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return SensorDeleteDialog(sensor: sensor);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    networkStatus =
        Provider.of<NetworkProvider>(context, listen: true).networkStatus;
    if (networkStatus) {
      Provider.of<SensorProvider>(context, listen: false).initializeList();
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: networkStatus
            ? () {
                Provider.of<SensorProvider>(context, listen: false)
                    .refreshList();
              }
            : null,
        child: Icon(
          Icons.refresh,
          color: Theme.of(context).cardColor,
        ),
      ),
      appBar: AppBar(
        title: const Text("Irrigation"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: networkStatus
                  ? () {
                      Get.to(() => const SensorAddPage());
                    }
                  : null,
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: const Drawer(),
      body: RefreshIndicator(
        onRefresh: () =>
            Provider.of<SensorProvider>(context, listen: false).refreshList(),
        child: Consumer<SensorProvider>(
          builder: (context, value, child) {
            switch (networkStatus) {
              case true:
                return value.getSensors.isEmpty
                    ? const Center(
                        child: Text("No sensors"),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Theme.of(context).primaryColor),
                              width: double.maxFinite,
                              height: size.height / 5,
                              child: const ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                child: MapWidget(),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: value.getSensors.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () => Get.to(SensorDetailPage(
                                          sensor: value.getSensors[index])),
                                      onLongPress: () => deleteSensorDialog(
                                          context, value.getSensors[index]),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: ValveListItem(
                                          sensor: value.getSensors[index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      );
              default:
                return const NoInternetWidget();
            }
          },
        ),
      ),
    );
  }
}
