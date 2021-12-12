//
//  ContentView.swift
//  Covid19API
//
//  Created by Kuba Milcarz on 11/12/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var dailySummary = [DailySummary]()
    @State private var orignalDailySummary = [DailySummary]()
    
    @State private var query = ""
    @State private var isDataLoaded = false
    
    var body: some View {
        NavigationView {
            List {
                Section("Global") {
                    HStack {
                        Text("New confirmed")
                        Spacer()
                        if isDataLoaded {
                            Text("\(dailySummary[0].Global.NewConfirmed)")
                                .font(.headline)
                        } else {
                            ProgressView()
                        }
                    }
                    HStack {
                        Text("Total confirmed")
                        Spacer()
                        if isDataLoaded {
                            Text("\(dailySummary[0].Global.TotalConfirmed)")
                                .font(.headline)
                        } else {
                            ProgressView()
                        }
                    }
                    HStack {
                        Text("New deaths")
                        Spacer()
                        if isDataLoaded {
                            Text("\(dailySummary[0].Global.NewDeaths)")
                                .font(.headline)
                        } else {
                            ProgressView()
                        }
                    }
                    HStack {
                        Text("Total Deaths")
                        Spacer()
                        if isDataLoaded {
                            Text("\(dailySummary[0].Global.TotalDeaths)")
                                .font(.headline)
                        } else {
                            ProgressView()
                        }
                    }
                }
                Section("Countries") {
                    if !dailySummary.isEmpty {
                        ForEach(dailySummary[0].Countries, id: \.ID) { country in
                            NavigationLink {
                                CountryDetail(countrySummary: country)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            AsyncImage(url: URL(string: "https://flagcdn.com/w80/\(country.CountryCode.lowercased()).jpg"), scale: 3) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            .frame(width: 50, height: 30)
                                            .clipShape(RoundedRectangle(cornerRadius: 3))
                                            Text(country.Country)
                                                .font(.headline)
                                        }.padding(.vertical, 8)
                                        
                                        Text("New cases: \(country.NewConfirmed)")
                                            .foregroundColor(.gray)
                                            .font(.subheadline)
                                    }
                                }
                            }
                            .redacted(reason: isDataLoaded ? [] : .placeholder)
                        }
                    }
                }
                
            }.searchable(text: $query)
            .task {
                await loadData()
            }
            .onChange(of: query) { query in
                if !query.isEmpty {
                    dailySummary[0].Countries = dailySummary[0].Countries.filter { $0.Country.contains(query) }
                } else {
                    dailySummary[0].Countries = orignalDailySummary[0].Countries
                }
            }
            
            .navigationTitle("Daily Cases")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(Date.now.formatted(date: .abbreviated, time: .omitted))
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    func loadData() async {
        guard dailySummary.isEmpty else { return }
        
        do {
            let url = URL(string: "https://api.covid19api.com/summary")!
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            let response = try decoder.decode(DailySummary.self, from: data)
            
            dailySummary = [response]
            dailySummary[0].Countries = dailySummary[0].Countries.sorted(by: { $0.NewConfirmed > $1.NewConfirmed })
            orignalDailySummary = dailySummary
            
            await MainActor.run {
                isDataLoaded = true
            }
        } catch {
            print("Downloading data failed.")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
