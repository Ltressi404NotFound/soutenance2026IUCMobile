import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/carnet_model.dart';
import '../services/database_service.dart';

class CarnetMedicalPage extends StatelessWidget {
  final String uid;
  CarnetMedicalPage({required this.uid});

  // Fonction pour générer et imprimer le PDF
  Future<void> _generatePdf(Carnet carnet) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Header(
              level: 0, 
              child: pw.Text("FIRSTAID LOUM - RAPPORT DE CONSULTATION", 
              style: pw.TextStyle(fontSize: 22))
            ),
            pw.SizedBox(height: 20),
            pw.Text("Patient : ${carnet.nomPatient}"),
            pw.Text("Date de consultation : ${DateFormat('dd/MM/yyyy').format(carnet.date)}"),
            pw.Divider(),
            pw.SizedBox(height: 10),
            pw.Text("ORDONNANCE :", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
            pw.Text(carnet.ordonnance),
            pw.SizedBox(height: 20),
            pw.Text("RÉSULTATS DE LABORATOIRE :", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
            pw.Text(carnet.resultatsLabo),
            pw.SizedBox(height: 40),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text("Généré via FirstAid Loum App", style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic)),
            )
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) => pdf.save(),
      name: 'Consultation_${DateFormat('ddMMyyyy').format(carnet.date)}.pdf'
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Mon Carnet Médical", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Carnet>>(
        stream: DatabaseService().getCarnetPatient(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text("Erreur lors de la récupération : ${snapshot.error}"));
          }

          var carnetList = snapshot.data ?? [];

          if (carnetList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open, size: 80, color: Colors.grey),
                  Text("Aucune consultation enregistrée.", style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: carnetList.length,
            itemBuilder: (context, index) {
              var doc = carnetList[index];
              return Card(
                elevation: 3,
                margin: EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.medical_services_outlined, color: Colors.blue[800]),
                              SizedBox(width: 10),
                              Text(
                                "Consultation du ${DateFormat('dd/MM/yyyy').format(doc.date)}",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.picture_as_pdf, color: Colors.red[700]),
                            onPressed: () => _generatePdf(doc),
                            tooltip: "Exporter en PDF",
                          )
                        ],
                      ),
                      Divider(),
                      SizedBox(height: 5),
                      Text("Ordonnance :", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900])),
                      Text(doc.ordonnance, maxLines: 2, overflow: TextOverflow.ellipsis),
                      SizedBox(height: 10),
                      Text("Résultats Labo :", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900])),
                      Text(doc.resultatsLabo, maxLines: 2, overflow: TextOverflow.ellipsis),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "Patient: ${doc.nomPatient}",
                          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}