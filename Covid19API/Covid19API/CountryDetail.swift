//
//  CountryDetail.swift
//  Covid19API
//
//  Created by Kuba Milcarz on 11/12/2021.
//

import SwiftUI

struct CountryDetail: View {
    var countrySummary: CountryDailySummary
    
    @State private var sevenDays = [CountryDailyCases]()

    var body: some View {
        List {
            Section("Summary") {
                HStack {
                    Text("New confirmed")
                    Spacer()
                    Text("\(countrySummary.NewConfirmed)")
                        .font(.headline)
                }
                HStack {
                    Text("Total confirmed")
                    Spacer()
                    Text("\(countrySummary.TotalConfirmed)")
                        .font(.headline)
                }
                HStack {
                    Text("New deaths")
                    Spacer()
                    Text("\(countrySummary.NewDeaths)")
                        .font(.headline)
                }
                HStack {
                    Text("Total deaths")
                    Spacer()
                    Text("\(countrySummary.TotalDeaths)")
                        .font(.headline)
                }
            }
            
            Section("Last 14 days") {
                ForEach(sevenDays, id: \.ID) { day in
                    VStack(alignment: .leading) {
                        Text("\(day.Date.formatted(date: .abbreviated, time: .omitted))")
                            .font(.headline)
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Confirmed")
                                Spacer()
                                Text("\(day.Confirmed)")
                            }
                            HStack {
                                Text("Death")
                                Spacer()
                                Text("\(day.Deaths)")
                            }
                            HStack {
                                Text("Recovered")
                                Spacer()
                                Text("\(day.Recovered)")
                            }
                        }
                        .font(.subheadline)
                        
                    }
                }
            }
        }
        .task {
            await loadData(for: countrySummary.Slug)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
              HStack {
                  AsyncImage(url: URL(string: "https://flagcdn.com/w80/\(countrySummary.CountryCode.lowercased()).jpg"), scale: 3) { image in
                      image
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                  } placeholder: {
                      ProgressView()
                  }
                  .frame(width: 30, height: 20)
                  .clipShape(RoundedRectangle(cornerRadius: 3))
                  Text(countrySummary.Country)
              }
          }
        }
    }
    
    func loadData(for slug: String) async {
        guard sevenDays.isEmpty else { return }
        
        do {
            let timeInterval = DateComponents(month: 0, day: -14, hour: 0, minute: 0, second: 0)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let start = dateFormatter.string(from: Calendar.current.date(byAdding: timeInterval, to: Date())!)

            let url = URL(string: "https://api.covid19api.com/live/country/\(slug)/status/confirmed/date/\(start)")!
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let response = try decoder.decode([CountryDailyCases].self, from: data)
            
            sevenDays = response.sorted(by: { $0.Date > $1.Date })
        } catch {
            print("Downloading data failed.")
        }
        
    }
}

struct CustomNavBar: View {
    
    var body: some View {
        VStack {
            Text("hello")
            Text("world mi")
            Text("amigo")
        }
    }
}
