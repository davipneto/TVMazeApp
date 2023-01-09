//
//  TVMazeAppTests.swift
//  TVMazeAppTests
//
//  Created by Davi Pereira on 08/01/23.
//

import XCTest
import SwiftyJSON
@testable import TVMazeApp

final class TVMazeAppTests: XCTestCase {
    var show = Show.randomShow()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetGenresFromShow() {
        show.genres = ["Comedy", "Drama", "Horror"]
        let viewModel = ShowDetailsViewModel(show: show)
        var genresString = viewModel.getGenres()
        XCTAssertEqual(genresString, "Comedy • Drama • Horror")
        viewModel.show.genres = []
        genresString = viewModel.getGenres()
        XCTAssertEqual(genresString, "")
    }
    
    func testGetScheduleDaysFromShow() {
        show.scheduleDays = ["Jan", "Fev", "Mar"]
        let viewModel = ShowDetailsViewModel(show: show)
        var scheduleDaysString = viewModel.getScheduleDays()
        XCTAssertEqual(scheduleDaysString, "Jan\nFev\nMar")
        viewModel.show.scheduleDays = []
        scheduleDaysString = viewModel.getScheduleDays()
        XCTAssertEqual(scheduleDaysString, "")
    }
    
    func testNavigationBarAlpha() {
        let viewModel = ShowDetailsViewModel(show: show)
        var alpha = viewModel.calculateNavigationBarAlpha(heightOffset: 0, nameLabelOriginY: 320, topBarHeight: 90, nameLabelHeight: 30)
        XCTAssertEqual(alpha, 0)
        alpha = viewModel.calculateNavigationBarAlpha(heightOffset: 230, nameLabelOriginY: 320, topBarHeight: 90, nameLabelHeight: 30)
        XCTAssertEqual(alpha, 0)
        alpha = viewModel.calculateNavigationBarAlpha(heightOffset: 260, nameLabelOriginY: 320, topBarHeight: 90, nameLabelHeight: 30)
        XCTAssertEqual(alpha, 1)
        alpha = viewModel.calculateNavigationBarAlpha(heightOffset: 245, nameLabelOriginY: 320, topBarHeight: 90, nameLabelHeight: 30)
        XCTAssertEqual(alpha, 0.5)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

private extension Show {
    static func randomShow() -> Show {
        let jsonString = """
        {"id":1,"url":"https://www.tvmaze.com/shows/1/under-the-dome","name":"Under the Dome","type":"Scripted","language":"English","genres":["Drama","Science-Fiction","Thriller"],"status":"Ended","runtime":60,"averageRuntime":60,"premiered":"2013-06-24","ended":"2015-09-10","officialSite":"http://www.cbs.com/shows/under-the-dome/","schedule":{"time":"22:00","days":["Thursday"]},"rating":{"average":6.5},"weight":98,"network":{"id":2,"name":"CBS","country":{"name":"United States","code":"US","timezone":"America/New_York"},"officialSite":"https://www.cbs.com/"},"webChannel":null,"dvdCountry":null,"externals":{"tvrage":25988,"thetvdb":264492,"imdb":"tt1553656"},"image":{"medium":"https://static.tvmaze.com/uploads/images/medium_portrait/81/202627.jpg","original":"https://static.tvmaze.com/uploads/images/original_untouched/81/202627.jpg"},"summary":"<p><b>Under the Dome</b> is the story of a small town that is suddenly and inexplicably sealed off from the rest of the world by an enormous transparent dome. The town's inhabitants must deal with surviving the post-apocalyptic conditions while searching for answers about the dome, where it came from and if and when it will go away.</p>","updated":1631010933,"_links":{"self":{"href":"https://api.tvmaze.com/shows/1"},"previousepisode":{"href":"https://api.tvmaze.com/episodes/185054"}}}
        """
        let json = JSON(stringLiteral: jsonString)
        return Show(from: json)
    }
}
