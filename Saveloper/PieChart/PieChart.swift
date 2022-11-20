//
//  PieChart.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 10.11.2022.
//

import SwiftUI

struct PieChart: View {
    
    @StateObject var pieChartViewModel: PieChartViewModel
    
    init(_ pieChartViewModel: PieChartViewModel) {
        _pieChartViewModel = .init(wrappedValue: pieChartViewModel)
    }
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.date)
    ]) var events: FetchedResults<Events>
    
    var body: some View {
        VStack {
            ZStack {
                GeometryReader { geometry in
                    ZStack {
                        ForEach(pieChartViewModel.createSlices(events: events), id: \.self) { item in
                            PieChartSlice(center: CGPoint(x: geometry.frame(in: .local).midX,
                                                          y: geometry.frame(in: .local).midY),
                                          radius: geometry.frame(in: .local).width/2,
                                          startDegree: item.startDegree,
                                          endDegree: item.endDegree,
                                          isTouched: pieChartViewModel.sliceIsTouched(slice: item,
                                                                                      inPie: geometry.frame(in: .local),
                                                                                      events: events),
                                          accentColor: Color.init(hex: item.event.color ?? "#2f4b7c"),
                                          separatorColor: .white)
                            .gesture(DragGesture(minimumDistance: 0)
                                .onChanged({ position in
                                    let pieSize = geometry.frame(in: .local)
                                    pieChartViewModel.touchLocation = position.location
                                    pieChartViewModel.updateCurrentValue(inPie: pieSize,
                                                                         events: events)
                                    pieChartViewModel.selectedEvent = item.event
                                    pieChartViewModel.showDetailedEvent.toggle()
                                })
                                    .onEnded({ _ in
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            withAnimation(Animation.easeOut) {
                                                pieChartViewModel.resetValues()
                                            }
                                        }
                                    })
                            )
                        }
                    }
                }
                .aspectRatio(contentMode: .fit)
                VStack {
                    if !pieChartViewModel.currentLabel.isEmpty {
                        Text(pieChartViewModel.currentLabel)
                            .font(.caption)
                            .bold()
                            .foregroundColor(.black)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.white).shadow(radius: 3))
                    }
                    
                    if !pieChartViewModel.currentValue.isEmpty {
                        Text("\(pieChartViewModel.currentValue)")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.black)
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.white).shadow(radius: 3))
                    }
                }
                .padding()
            }
        }
        .padding()
    }
}
