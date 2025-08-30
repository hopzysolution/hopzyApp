// // 6. Responsive HTML Generator for Trip Plan
// import 'package:ridebooking/models/trip_plan_request.dart';

// class TripPlanHtmlGenerator {
//   static String generateHtml(TripPlan tripPlan, TripPlanRequest request) {
//     return '''
//     <!DOCTYPE html>
//     <html>
//     <head>
//         <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
//         <meta charset="UTF-8">
//         <style>
//             ${_getResponsiveStyles()}
//         </style>
//     </head>
//     <body>
//         ${_generateTripSummary(request)}
//         ${tripPlan.specialMessage != null ? _generateSpecialMessage(tripPlan.specialMessage!) : ''}
//         ${_generateItinerary(tripPlan.itinerary)}
//         ${_generateRestaurants(tripPlan.restaurantRecommendations)}
//     </body>
//     </html>
//     ''';
//   }

//   static String _getResponsiveStyles() {
//     return '''
//         * {
//             box-sizing: border-box;
//         }
        
//         body { 
//             font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; 
//             margin: 0; 
//             padding: 0px; 
//             background-color: #f8f9fa; 
//             color: #1a1a1a;
//             line-height: 1.6;
//             font-size: 16px;
//             -webkit-text-size-adjust: 100%;
//             -ms-text-size-adjust: 100%;
//         }
        
//         /* Base container styles */
//         .container {
//             max-width: 100%;
//             margin: 0 auto;
//         }
        
//         /* Trip Summary Card - Fully Responsive */
//         .trip-summary-card {
//             background: #fff;
//             border: 1px solid #E2E8F0;
//             border-radius: 8px;
//             padding: 16px;
//             box-shadow: 0 2px 4px rgba(0,0,0,.1);
//             margin-bottom: 16px;
//             width: 100%;
//         }
        
//         .trip-summary-card h2 {
//             text-align: center;
//             font-size: clamp(18px, 4vw, 24px);
//             font-weight: 700;
//             margin: 0 0 16px 0;
//             color: #0047ff;
//             word-wrap: break-word;
//         }
        
//         .summary-grid {
//             display: grid;
//             grid-template-columns: 1fr;
//             gap: 10px;
//             margin-bottom: 16px;
//             width: 100%;
//         }
        
//         .summary-item {
//     background-color: #f9f9f9;
//     padding: 8px 10px; /* More vertical padding */
//     border-radius: 6px;
//     border: 1px solid #E2E8F0;
//     display: flex;
//     flex-direction: column;
//     justify-content: flex-start;
//     word-break: break-word;
//     overflow: hidden;
//     min-height: fit-content; /* Ensure container grows with content */
// }
        
//         .summary-item strong {
//             display: block;
//             margin-bottom: 3px;
//             color: #555;
//             font-size: 14px;
//             font-weight: 600;
//             line-height: 1.8;
//         }
        
//         .summary-item p {
//     margin: 0;
//     font-size: clamp(13px, 3.2vw, 15px);
//     font-weight: 500;
//     word-wrap: break-word;
//     overflow-wrap: break-word;
//     line-height: 1.5; /* Looser spacing so letters don't clip */
//     max-width: 100%;
// }
        
//         /* Special Message - Responsive */
//         .special-message-box {
//             padding: 12px 16px;
//             border-left: 4px solid #f0ad4e;
//             background-color: #fcf8e3;
//             color: #8a6d3b;
//             border-radius: 6px;
//             line-height: 1.5;
//             margin-bottom: 16px;
//             font-size: clamp(14px, 3.5vw, 16px);
//             word-wrap: break-word;
//             overflow-wrap: break-word;
//         }
        
//         /* Headers - Responsive Typography */
//         h2 {
//             font-size: clamp(20px, 5vw, 28px);
//             font-weight: 700;
//             margin: 24px 0 12px 0;
//             padding-bottom: 6px;
//             border-bottom: 2px solid #1a1a1a;
//             word-wrap: break-word;
//         }
        
//         h3 {
//             margin: 20px 0 12px 0;
//             color: #0047ff;
//             font-size: clamp(16px, 4vw, 20px);
//             font-weight: 600;
//             word-wrap: break-word;
//             overflow-wrap: break-word;
//         }
        
//         /* Activity Container - Mobile First */
//         .activity-container {
//             background-color: #ffffff;
//             border: 1px solid #E2E8F0;
//             border-radius: 8px;
//             padding: 12px;
//             box-shadow: 0 2px 4px rgba(0,0,0,.05);
//             margin: 12px 0;
//             width: 100%;
//             overflow: hidden;
//         }
        
//         .activity-detail-card, .why-famous-card {
//             padding: 12px;
//             border-radius: 6px;
//             margin-bottom: 12px;
//             width: 100%;
//             overflow: hidden;
//         }
        
//         .activity-detail-card {
//             background-color: #FFE5D4;
//             border-left: 3px solid #ff8055;
//         }
        
//         .why-famous-card {
//             background-color: #E3F2FD;
//             border-left: 3px solid #0047ff;
//             margin-bottom: 0;
//         }
        
//         .activity-name {
//             font-weight: 600;
//             font-size: clamp(16px, 4vw, 20px);
//             margin: 0 0 8px 0;
//             color: #1a1a1a;
//             word-wrap: break-word;
//             overflow-wrap: break-word;
//             line-height: 1.3;
//         }
        
//         .activity-description {
//             color: #718096;
//             line-height: 1.5;
//             margin: 0;
//             font-size: clamp(14px, 3.5vw, 16px);
//             word-wrap: break-word;
//             overflow-wrap: break-word;
//         }
        
//         .activity-container ul {
//             padding-left: 16px;
//             margin: 8px 0 0 0;
//             color: #718096;
//         }
        
//         .activity-container ul li {
//             margin-bottom: 6px;
//             font-size: clamp(13px, 3.2vw, 15px);
//             word-wrap: break-word;
//             overflow-wrap: break-word;
//             line-height: 1.4;
//         }
        
//         .activity-container strong {
//             color: #2D3748;
//             font-size: clamp(14px, 3.5vw, 16px);
//             font-weight: 600;
//         }
        
//         /* Restaurant Cards - Mobile Optimized */
//         .card-grid {
//             display: grid;
//             grid-template-columns: 1fr;
//             gap: 12px;
//             margin: 16px 0;
//             width: 100%;
//         }
        
//         .restaurant-card {
//             background-color: #ffffff;
//             border: 1px solid #E2E8F0;
//             border-left: 4px solid #0047ff;
//             border-radius: 8px;
//             padding: 16px;
//             box-shadow: 0 2px 4px rgba(0,0,0,.06);
//             color: #2D3748;
//             width: 100%;
//             overflow: hidden;
//         }
        
//         .restaurant-card:nth-child(even) {
//             border-left-color: #ff8055;
//         }
        
//         .card-header {
//             display: flex;
//             justify-content: space-between;
//             align-items: flex-start;
//             margin-bottom: 8px;
//             gap: 8px;
//             flex-wrap: wrap;
//         }
        
//         .restaurant-name {
//             font-weight: 600;
//             font-size: clamp(16px, 4vw, 18px);
//             margin: 0;
//             word-wrap: break-word;
//             overflow-wrap: break-word;
//             flex: 1;
//             min-width: 0;
//             line-height: 1.3;
//         }
        
//         .rating {
//             display: inline-flex;
//             align-items: center;
//             gap: 2px;
//             font-weight: 600;
//             color: #fff;
//             background-color: #ff8055;
//             padding: 4px 8px;
//             border-radius: 4px;
//             white-space: nowrap;
//             font-size: clamp(12px, 3vw, 14px);
//             flex-shrink: 0;
//         }
        
//         .restaurant-details {
//             font-size: clamp(13px, 3.2vw, 15px);
//             color: #2D3748;
//             margin: 0 0 12px 0;
//             word-wrap: break-word;
//             overflow-wrap: break-word;
//             line-height: 1.4;
//         }
        
//         .cuisine-line {
//             display: flex;
//             justify-content: space-between;
//             align-items: flex-start;
//             gap: 12px;
//             margin-top: 8px;
//             flex-wrap: wrap;
//         }
        
//         .cuisine-info {
//             display: flex;
//             align-items: center;
//             gap: 6px;
//             flex: 1;
//             min-width: 0;
//         }
        
//         .cuisine-text {
//             margin: 0;
//             font-size: clamp(12px, 3vw, 14px);
//             color: #718096;
//             word-wrap: break-word;
//             overflow-wrap: break-word;
//         }
        
//         .timing-info {
//             display: flex;
//             align-items: center;
//             gap: 4px;
//             font-size: clamp(11px, 2.8vw, 13px);
//             color: #1a1a1a;
//             flex-shrink: 0;
//             word-wrap: break-word;
//             overflow-wrap: break-word;
//         }
        
//         .food-type-badge {
//             display: inline-block;
//             padding: 2px 6px;
//             border-radius: 3px;
//             font-size: clamp(10px, 2.5vw, 12px);
//             font-weight: 600;
//             white-space: nowrap;
//             flex-shrink: 0;
//         }
        
//         .veg { background-color: #4CAF50; color: white; }
//         .non-veg { background-color: #E53935; color: white; }
//         .mixed { background-color: #FF9800; color: white; }
        
//         /* Responsive breakpoints */
        
//         /* Small phones (320px - 480px) */
//         @media (max-width: 480px) {
//             body {
//                 padding: 4px;
//                 font-size: 14px;
//             }
            
//             .trip-summary-card {
//                 padding: 10px;
//             }
            
//             .summary-item {
//                 padding: 8px;
//                 min-height: auto;
//             }
            
//             .summary-item strong {
//                 font-size: 11px;
//                 margin-bottom: 2px;
//             }
            
//             .summary-item p {
//                 font-size: 12px;
//                 line-height: 1.2;
//             }
            
//             .activity-container, .restaurant-card {
//                 padding: 12px;
//             }
            
//             .activity-detail-card, .why-famous-card {
//                 padding: 10px;
//             }
            
//             .card-header {
//                 flex-direction: column;
//                 align-items: flex-start;
//                 gap: 6px;
//             }
            
//             .cuisine-line {
//                 flex-direction: column;
//                 gap: 8px;
//                 align-items: stretch;
//             }
            
//             .timing-info {
//                 align-self: flex-start;
//             }
//         }
        
//         /* Large phones (481px - 768px) */
//         @media (min-width: 481px) and (max-width: 768px) {
//             body {
//                 padding: 12px;
//             }
            
//             .summary-grid {
//                 grid-template-columns: repeat(2, 1fr);
//                 gap: 16px;
//             }
            
//             .card-grid {
//                 gap: 16px;
//             }
//         }
        
//         /* Tablets (769px - 1024px) */
//         @media (min-width: 769px) and (max-width: 1024px) {
//             body {
//                 padding: 16px;
//                 max-width: 800px;
//                 margin: 0 auto;
//             }
            
//             .summary-grid {
//                 grid-template-columns: repeat(2, 1fr);
//                 gap: 20px;
//             }
            
//             .card-grid {
//                 grid-template-columns: repeat(2, 1fr);
//                 gap: 20px;
//             }
            
//             .activity-container {
//                 display: grid;
//                 grid-template-columns: 1fr 1fr;
//                 gap: 16px;
//                 align-items: start;
//             }
            
//             .activity-detail-card, .why-famous-card {
//                 margin-bottom: 0;
//             }
//         }
        
//         /* Large tablets and small desktops (1025px+) */
//         @media (min-width: 1025px) {
//             body {
//                 padding: 20px;
//                 max-width: 1000px;
//                 margin: 0 auto;
//             }
            
//             .summary-grid {
//                 grid-template-columns: repeat(4, 1fr);
//                 gap: 24px;
//             }
            
//             .card-grid {
//                 grid-template-columns: repeat(2, 1fr);
//                 gap: 24px;
//             }
            
//             .activity-container {
//                 display: grid;
//                 grid-template-columns: 1.2fr 0.8fr;
//                 gap: 20px;
//                 align-items: start;
//             }
//         }
        
//         /* Accessibility improvements */
//         @media (prefers-reduced-motion: reduce) {
//             * {
//                 animation-duration: 0.01ms !important;
//                 animation-iteration-count: 1 !important;
//                 transition-duration: 0.01ms !important;
//             }
//         }
        
//         /* High contrast mode support */
//         @media (prefers-contrast: high) {
//             .activity-detail-card {
//                 border-left-width: 5px;
//             }
            
//             .why-famous-card {
//                 border-left-width: 5px;
//             }
            
//             .restaurant-card {
//                 border-left-width: 6px;
//             }
//         }
        
//         /* Dark mode support (if needed) */
//         @media (prefers-color-scheme: dark) {
//             body {
//                 background-color: #1a1a1a;
//                 color: #ffffff;
//             }
            
//             .trip-summary-card, .activity-container, .restaurant-card {
//                 background-color: #2d2d2d;
//                 border-color: #444;
//             }
            
//             .summary-item {
//                 background-color: #333;
//                 border-color: #444;
//             }
            
//             .activity-detail-card {
//                 background-color: #2a1810;
//             }
            
//             .why-famous-card {
//                 background-color: #0a1a2a;
//             }
            
//             .special-message-box {
//                 background-color: #2a2416;
//                 color: #d4b851;
//             }
//         }
        
//         /* Print styles */
//         @media print {
//             body {
//                 background: white;
//                 color: black;
//                 font-size: 12pt;
//                 line-height: 1.4;
//             }
            
//             .trip-summary-card, .activity-container, .restaurant-card {
//                 box-shadow: none;
//                 border: 1px solid #ccc;
//                 break-inside: avoid;
//             }
            
//             h2, h3 {
//                 break-after: avoid;
//             }
//         }
//     ''';
//   }

//   static String _generateTripSummary(TripPlanRequest request) {
//     return '''
//     <div class="container">
//         <div class="trip-summary-card">
//             <h2>Your Trip Details</h2>
//             <div class="summary-grid">
//                 <div class="summary-item">
//                     <strong>Destination:</strong>
//                     <p>${_escapeHtml(request.destination)}</p>
//                 </div>
//                 <div class="summary-item">
//                     <strong>Duration:</strong>
//                     <p>${request.duration} day${request.duration > 1 ? 's' : ''}</p>
//                 </div>
//                 <div class="summary-item">
//                     <strong>People:</strong>
//                     <p>${request.people} ${request.people > 1 ? 'travelers' : 'traveler'}</p>
//                 </div>
//                 <div class="summary-item">
//                     <strong>Travel Style:</strong>
//                     <p>${_escapeHtml(request.travelStyle)}</p>
//                 </div>
//             </div>
//         </div>
//     </div>
//     ''';
//   }

//   static String _generateSpecialMessage(String message) {
//     return '''
//     <div class="container">
//         <div class="special-message-box">
//             ${_escapeHtml(message)}
//         </div>
//     </div>
//     ''';
//   }

//   static String _generateItinerary(List<DayItinerary> itinerary) {
//     if (itinerary.isEmpty) return '';
    
//     String html = '''
//     <div class="container">
//         <h2>Your Itinerary</h2>
//     ''';
    
//     for (var day in itinerary) {
//       html += '<h3>Day ${day.day}: ${_escapeHtml(day.title)}</h3>';
      
//       for (var activity in day.activities) {
//         String whyFamousList = '';
//         if (activity.whyFamous.isNotEmpty) {
//           whyFamousList = '<ul>';
//           for (var point in activity.whyFamous) {
//             whyFamousList += '<li>${_escapeHtml(point)}</li>';
//           }
//           whyFamousList += '</ul>';
//         } else {
//           whyFamousList = '<p style="margin: 0; font-style: italic; color: #999;">No additional information available</p>';
//         }
        
//         html += '''
//         <div class="activity-container">
//             <div class="activity-detail-card">
//                 <p class="activity-name">${_escapeHtml(activity.name)}</p>
//                 <p class="activity-description">${_escapeHtml(activity.description)}</p>
//             </div>
//             <div class="why-famous-card">
//                 <strong>Why Famous:</strong>
//                 $whyFamousList
//             </div>
//         </div>
//         ''';
//       }
//     }
    
//     html += '</div>';
//     return html;
//   }

//   static String _generateRestaurants(List<Restaurant> restaurants) {
//     if (restaurants.isEmpty) return '';
    
//     String html = '''
//     <div class="container">
//         <h2>Restaurant Suggestions</h2>
//         <p style="margin-top: 12px; font-size: clamp(14px, 3.5vw, 16px); color: #555555; padding-bottom: 16px;">Based on 2k+ Traveller Reviews.</p>
//         <div class="card-grid">
//     ''';
    
//     for (var restaurant in restaurants) {
//       String foodTypeBadge = '';
//       if (restaurant.foodType.isNotEmpty) {
//         String badgeClass = 'mixed';
//         if (restaurant.foodType == 'Veg') badgeClass = 'veg';
//         if (restaurant.foodType == 'Non-Veg') badgeClass = 'non-veg';
        
//         foodTypeBadge = '<span class="food-type-badge $badgeClass">${_escapeHtml(restaurant.foodType)}</span>';
//       }
      
//       String ratingBadge = '';
//       if (restaurant.rating.isNotEmpty) {
//         String ratingValue = restaurant.rating.split('/')[0];
//         ratingBadge = '<span class="rating">★ ${_escapeHtml(ratingValue)}</span>';
//       }
      
//       String timingInfo = '';
//       if (restaurant.timing.isNotEmpty) {
//         timingInfo = '<div class="timing-info">🕒 ${_escapeHtml(restaurant.timing)}</div>';
//       }
      
//       html += '''
//       <div class="restaurant-card">
//           <div class="card-header">
//               <div class="restaurant-name">${_escapeHtml(restaurant.name)}</div>
//               $ratingBadge
//           </div>
//           <p class="restaurant-details">${_escapeHtml(restaurant.details)}</p>
//           <div class="cuisine-line">
//               <div class="cuisine-info">
//                   $foodTypeBadge
//                   <p class="cuisine-text">${_escapeHtml(restaurant.cuisine)}</p>
//               </div>
//               $timingInfo
//           </div>
//       </div>
//       ''';
//     }
    
//     html += '''
//         </div>
//     </div>
//     ''';
//     return html;
//   }

//   // Helper method to escape HTML characters for security
//   static String _escapeHtml(String text) {
//     return text
//         .replaceAll('&', '&amp;')
//         .replaceAll('<', '&lt;')
//         .replaceAll('>', '&gt;')
//         .replaceAll('"', '&quot;')
//         .replaceAll("'", '&#x27;');
//   }
// }