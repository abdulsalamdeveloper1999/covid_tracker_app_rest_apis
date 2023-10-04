import 'package:covid_tracker/core/services/states_services.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CountriesScreen extends StatefulWidget {
  const CountriesScreen({Key? key}) : super(key: key);

  @override
  _CountriesScreenState createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  TextEditingController searchController = TextEditingController();
  StatesSevices statesServices = StatesSevices(); // Use the same instance

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Countries'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              onChanged: (value) {
                setState(() {});
              },
              controller: searchController,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    searchController.clear(); // Clear search text
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                ),
                hintText: 'Search Country',
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15,
                ),
                hintStyle: const TextStyle(fontSize: 14),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: statesServices.fetchCountryStatesApi(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Display shimmer loading
                  return _buildShimmerLoading();
                } else if (snapshot.hasError) {
                  // Display error message
                  return Text(snapshot.error.toString());
                } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                  // Handle empty data case
                  return const Text("No data available");
                } else {
                  // Display country list
                  return _buildCountryList(snapshot.data);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade700,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: Container(
                  width: 25,
                  color: Colors.grey.shade700,
                ),
                title: Container(
                  height: 10,
                  color: Colors.grey.shade700,
                ),
                subtitle: Container(
                  height: 10,
                  color: Colors.grey.shade700,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCountryList(data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          String name = data[index]['country'];
          if (searchController.text.isEmpty ||
              name
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase())) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Image.network(
                    data[index]['countryInfo']['flag'],
                    height: 25,
                    width: 25,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    name,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }
          return const SizedBox
              .shrink(); // Return an empty widget for non-matching items
        },
      ),
    );
  }
}
