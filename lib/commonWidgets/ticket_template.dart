// class TicketTemplate {
//   static String generateHtml() {
//     return """
// <!DOCTYPE html>
// <html lang="en">
// <head>
//     <meta charset="UTF-8">
//     <meta name="viewport" content="width=device-width, initial-scale=1.0">
//     <title>Bus Ticket</title>
//     <style>
//         * {
//             margin: 0;
//             padding: 0;
//         }
        
//         body {
//             font-family: Arial, sans-serif;
//             background-color: white;
//             padding: 10px;
//             font-size: 12px;
//         }
        
//         .ticket-container {
//             width: 100%;
//             border: 2px solid #333;
//             background: white;
//         }
        
//         /* Header */
//         .ticket-header {
//             background: white;
//             padding: 15px;
//             text-align: center;
//             border-bottom: 1px solid #333;
//         }
        
//         .logo {
//             font-size: 18px;
//             font-weight: bold;
//             color: #333;
//             margin-bottom: 5px;
//         }
        
//         .operator-name {
//             font-size: 16px;
//             font-weight: bold;
//             color: #333;
//             margin-bottom: 5px;
//         }
        
//         .ticket-status {
//             font-size: 12px;
//             color: #666;
//             margin-bottom: 8px;
//         }
        
//         .pnr-info {
//             font-size: 11px;
//             color: #333;
//         }
        
//         /* Sections */
//         .section {
//             padding: 15px;
//             border-bottom: 1px solid #ddd;
//         }
        
//         .section-title {
//             font-size: 14px;
//             font-weight: bold;
//             color: #333;
//             margin-bottom: 10px;
//             background-color: #f0f0f0;
//             padding: 5px;
//         }
        
//         /* Tables - Simplified */
//         .info-table {
//             width: 100%;
//             border-collapse: collapse;
//             margin-bottom: 15px;
//         }
        
//         .info-table th {
//             background-color: #333;
//             color: white;
//             padding: 8px;
//             text-align: center;
//             font-size: 11px;
//             font-weight: bold;
//             border: 1px solid #333;
//         }
        
//         .info-table td {
//             padding: 8px;
//             text-align: center;
//             font-size: 10px;
//             color: #333;
//             border: 1px solid #333;
//         }
        
//         /* Payment table */
//         .payment-table th {
//             background-color: #f0f0f0;
//             color: #333;
//             text-align: left;
//             font-weight: bold;
//             width: 30%;
//         }
        
//         .payment-table td {
//             text-align: left;
//             width: 70%;
//         }
        
//         /* Footer */
//         .footer {
//             padding: 15px;
//             text-align: center;
//             background: #f0f0f0;
//             font-size: 10px;
//             color: #666;
//             font-style: italic;
//         }
        
//         /* Remove complex properties that might not work in PDF */
//         .hopzy-logo .hopzy-o {
//             color: #0066cc;
//         }
//     </style>
// </head>
// <body>
//     <div class="ticket-container">
//         <!-- Header -->
//         <div class="ticket-header">
//             <div class="logo hopzy-logo">
//                 H<span class="hopzy-o">o</span>pzy
//             </div>
//             <div class="operator-name">{{OPERATOR_NAME}}</div>
//             <div class="ticket-status">Bus Ticket - {{TICKET_STATUS}}</div>
//             <div class="pnr-info">
//                 <div>PNR: {{PNR}}</div>
//                 <div>Ticket Id: {{TICKET_ID}}</div>
//             </div>
//         </div>
        
//         <!-- Trip Information -->
//         <div class="section">
//             <div class="section-title">Trip Information</div>
//             <table class="info-table">
//                 <thead>
//                     <tr>
//                         <th>From</th>
//                         <th>To</th>
//                         <th>Booked At</th>
//                     </tr>
//                 </thead>
//                 <tbody>
//                     <tr>
//                         <td>{{FROM}}</td>
//                         <td>{{TO}}</td>
//                         <td>{{BOOKED_AT}}</td>
//                     </tr>
//                 </tbody>
//             </table>
            
//             <table class="info-table">
//                 <thead>
//                     <tr>
//                         <th>Bus Type</th>
//                         <th>Prime Departure Time</th>
//                     </tr>
//                 </thead>
//                 <tbody>
//                     <tr>
//                         <td>{{BUS_TYPE}}</td>
//                         <td>{{PRIME_DEPARTURE_TIME}}</td>
//                     </tr>
//                 </tbody>
//             </table>
            
//             <!-- Boarding Info -->
//             <table class="info-table">
//                 <thead>
//                     <tr>
//                         <th>Boarding</th>
//                         <th>Address</th>
//                         <th>Time</th>
//                         <th>Contact</th>
//                     </tr>
//                 </thead>
//                 <tbody>
//                     <tr>
//                         <td>{{BOARDING_VENUE}}</td>
//                         <td>{{BOARDING_ADDRESS}}</td>
//                         <td>{{BOARDING_TIME}}</td>
//                         <td>{{BOARDING_CONTACT}}</td>
//                     </tr>
//                 </tbody>
//             </table>
            
//             <!-- Dropping Info -->
//             <table class="info-table">
//                 <thead>
//                     <tr>
//                         <th>Dropping</th>
//                         <th>Address</th>
//                         <th>Time</th>
//                         <th>Contact</th>
//                     </tr>
//                 </thead>
//                 <tbody>
//                     <tr>
//                         <td>{{DROPPING_VENUE}}</td>
//                         <td>{{DROPPING_ADDRESS}}</td>
//                         <td>{{DROPPING_TIME}}</td>
//                         <td>{{DROPPING_CONTACT}}</td>
//                     </tr>
//                 </tbody>
//             </table>
//         </div>
        
//         <!-- Passenger Details -->
//         <div class="section">
//             <div class="section-title">Passenger Details</div>
//             <table class="info-table">
//                 <thead>
//                     <tr>
//                         <th>#</th>
//                         <th>Name</th>
//                         <th>Gender</th>
//                         <th>Age</th>
//                         <th>Seat</th>
//                         <th>Fare</th>
//                     </tr>
//                 </thead>
//                 <tbody>
//                     {{PASSENGER_ROWS}}
//                 </tbody>
//             </table>
//         </div>
        
//         <!-- Cancellation Policy -->
//         <div class="section">
//             <div class="section-title">Cancellation Policy</div>
//             <table class="info-table">
//                 <thead>
//                     <tr>
//                         <th>#</th>
//                         <th>Description</th>
//                         <th>Refund</th>
//                         <th>Charge</th>
//                     </tr>
//                 </thead>
//                 <tbody>
//                     {{CANCELLATION_POLICY_ROWS}}
//                 </tbody>
//             </table>
//         </div>
        
//         <!-- Payment Information -->
//         <div class="section">
//             <div class="section-title">Payment Information</div>
//             <table class="info-table payment-table">
//                 <tbody>
//                     <tr>
//                         <th>Status</th>
//                         <td>{{PAYMENT_STATUS}}</td>
//                     </tr>
//                     <tr>
//                         <th>Payment ID</th>
//                         <td>{{PAYMENT_ID}}</td>
//                     </tr>
//                     <tr>
//                         <th>Amount Paid</th>
//                         <td>{{AMOUNT_PAID}}</td>
//                     </tr>
//                 </tbody>
//             </table>
//         </div>
        
//         <!-- Footer -->
//         <div class="footer">
//             Thank you for booking with HOPZY. Please carry a valid ID proof.
//         </div>
//     </div>
// </body>
// </html>
// """;
//   }
// }