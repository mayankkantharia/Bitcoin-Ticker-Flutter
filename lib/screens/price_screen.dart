import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_bitcoin_ticker/services/coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  PriceScreenState createState() => PriceScreenState();
}

class PriceScreenState extends State<PriceScreen> {
  String? selectedCurrency = 'AUD';
  bool isLoading = true;

  List<DropdownMenuItem<String>> myDropDown() {
    return currenciesList.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Center(
          child: Text(
            value,
          ),
        ),
      );
    }).toList();
  }

  DropdownButton<String> androidDropDownButton() {
    return DropdownButton<String>(
      value: selectedCurrency,
      items: myDropDown(),
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      children: myDropDown(),
      onSelectedItemChanged: (index) {
        setState(() {
          selectedCurrency = currenciesList[index];
          getData();
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Map<String, String> coinValues = {};

  void getData() async {
    isLoading = true;
    try {
      var data = await CoinData().getCoinData(currency: selectedCurrency);
      setState(() {
        coinValues = data;
        isLoading = false;
      });
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CoinCard(
                cryptoCurrency: cryptoList[0],
                value: isLoading ? '?' : coinValues['BTC'],
                selectedCurrency: selectedCurrency,
              ),
              CoinCard(
                cryptoCurrency: cryptoList[1],
                value: isLoading ? '?' : coinValues['ETH'],
                selectedCurrency: selectedCurrency,
              ),
              CoinCard(
                cryptoCurrency: cryptoList[2],
                value: isLoading ? '?' : coinValues['LTC'],
                selectedCurrency: selectedCurrency,
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            color: Colors.lightBlue,
            child: Center(
              child: Platform.isIOS ? iosPicker() : androidDropDownButton(),
            ),
          ),
        ],
      ),
    );
  }
}

class CoinCard extends StatelessWidget {
  const CoinCard({
    Key? key,
    required this.cryptoCurrency,
    required this.value,
    required this.selectedCurrency,
  }) : super(key: key);
  final String cryptoCurrency;
  final String? value;
  final String? selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 28.0,
          ),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
