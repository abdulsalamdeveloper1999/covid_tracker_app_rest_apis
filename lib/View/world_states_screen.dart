import 'package:covid_tracker/View/countries_screen.dart';
import 'package:covid_tracker/core/models/world_states_model.dart';
import 'package:covid_tracker/core/services/states_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStatesScreen extends StatefulWidget {
  const WorldStatesScreen({super.key});

  @override
  State<WorldStatesScreen> createState() => _WorldStatesScreenState();
}

class _WorldStatesScreenState extends State<WorldStatesScreen> {
  var colorList = [
    const Color(0xff4285f4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatesSevices statesSevices = StatesSevices();
    var s = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: s.height * 0.09),
            FutureBuilder(
              future: statesSevices.fetchWorldStatesApi(),
              builder: (BuildContext context,
                  AsyncSnapshot<WorldStatesModel> snapshot) {
                if (!snapshot.hasData) {
                  return const SpinKitFadingCircle(
                    color: Colors.white,
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        PieChart(
                          chartRadius: s.width * 0.4,
                          animationDuration: const Duration(milliseconds: 1200),
                          colorList: colorList,
                          chartType: ChartType.ring,
                          chartValuesOptions: const ChartValuesOptions(
                              showChartValuesInPercentage: true),
                          legendOptions: const LegendOptions(
                            legendPosition: LegendPosition.left,
                          ),
                          dataMap: {
                            'Total': snapshot.data!.population!.toDouble(),
                            'Recovered': snapshot.data!.recovered!.toDouble(),
                            'Death': snapshot.data!.deaths!.toDouble(),
                          },
                        ),
                        SizedBox(height: s.height * 0.05),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              resuableRow(
                                key: 'Total',
                                value: '${snapshot.data!.population!}',
                              ),
                              resuableRow(
                                key: 'Recovered',
                                value: '${snapshot.data!.deaths!}',
                              ),
                              resuableRow(
                                key: 'Death',
                                value: '${snapshot.data!.deaths!}',
                              ),
                              resuableRow(
                                key: 'Active',
                                value: '${snapshot.data!.active!}',
                              ),
                              resuableRow(
                                key: 'Critical',
                                value: '${snapshot.data!.critical!}',
                              ),
                              resuableRow(
                                key: 'Today Deaths',
                                value: '${snapshot.data!.todayDeaths!}',
                              ),
                              resuableRow(
                                key: 'Today Recovered',
                                value: '${snapshot.data!.todayRecovered!}',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: s.height * 0.04),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CountriesScreen()));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color(0xff1aa260),
                            ),
                            child: const Center(
                              child: Text(
                                'Track Country',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  resuableRow({required String key, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(key),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
