import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:resume_builder/config/app_routes.dart';
import 'package:resume_builder/model/invoice_model.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('Build Resume')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        children: [
          const Text('Create'),
          const SizedBox(height: 6),
          Row(
            children: [
              Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                color: const Color(0xffF5F5F5),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(AppRoutes.mainFormPage);
                  },
                  child: SizedBox(
                    height: 120,
                    width: (width - 32) / 2,
                    child: Column(
                      children: [
                        const Expanded(child: Icon(Icons.edit)),
                        Container(
                          height: 30,
                          color: Colors.grey,
                          width: double.infinity,
                          child: const Center(child: Text("Resume")),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                color: const Color(0xffF5F5F5),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(AppRoutes.coverLetterPage);
                  },
                  child: SizedBox(
                    height: 120,
                    width: (width - 32) / 2,
                    child: Column(
                      children: [
                        Expanded(
                          child: SvgPicture.asset(
                            'assets/splash.svg',
                            height: 50,
                          ),
                        ),
                        Container(
                          height: 30,
                          color: Colors.grey,
                          width: double.infinity,
                          child: const Center(child: Text("CV or Resume")),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                color: const Color(0xffF5F5F5),
                child: InkWell(
                  onTap: () {},
                  child: SizedBox(
                    height: 120,
                    width: (width - 32) / 2,
                    child: Column(
                      children: [
                        Expanded(
                          child: SvgPicture.asset(
                            'assets/splash.svg',
                            height: 50,
                          ),
                        ),
                        Container(
                          height: 30,
                          color: Colors.grey,
                          width: double.infinity,
                          child:
                              const Center(child: Text("Resignation Letter")),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                color: const Color(0xffF5F5F5),
                child: SizedBox(
                  height: 120,
                  width: (width - 32) / 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: SvgPicture.asset(
                          'assets/splash.svg',
                          height: 50,
                        ),
                      ),
                      Container(
                        height: 30,
                        color: Colors.grey,
                        width: double.infinity,
                        child: const Center(child: Text("Promotion Letter")),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static final date = DateTime.now();

  final invoice = Invoice(
    supplier: const Supplier(
      name: 'Sarah Field',
      address: 'Sarah Street 9, Beijing, China',
      paymentInfo: 'https://paypal.me/sarahfieldzz',
    ),
    customer: const Customer(
      name: 'Apple Inc.',
      address: 'Apple Street, Cupertino, CA 95014',
    ),
    info: InvoiceInfo(
      date: date,
      dueDate: date.add(const Duration(days: 7)),
      description: 'My description...',
      number: '${DateTime.now().year}-9999',
    ),
    items: [
      InvoiceItem(
        description: 'Coffee',
        date: DateTime.now(),
        quantity: 3,
        vat: 0.19,
        unitPrice: 5.99,
      ),
      InvoiceItem(
        description: 'Water',
        date: DateTime.now(),
        quantity: 8,
        vat: 0.19,
        unitPrice: 0.99,
      ),
      InvoiceItem(
        description: 'Orange',
        date: DateTime.now(),
        quantity: 3,
        vat: 0.19,
        unitPrice: 2.99,
      ),
      InvoiceItem(
        description: 'Apple',
        date: DateTime.now(),
        quantity: 8,
        vat: 0.19,
        unitPrice: 3.99,
      ),
      InvoiceItem(
        description: 'Mango',
        date: DateTime.now(),
        quantity: 1,
        vat: 0.19,
        unitPrice: 1.59,
      ),
      InvoiceItem(
        description: 'Blue Berries',
        date: DateTime.now(),
        quantity: 5,
        vat: 0.19,
        unitPrice: 0.99,
      ),
      InvoiceItem(
        description: 'Lemon',
        date: DateTime.now(),
        quantity: 4,
        vat: 0.19,
        unitPrice: 1.29,
      ),
    ],
  );
}
