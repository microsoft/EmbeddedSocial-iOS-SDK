//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class ReportPresenterTests: XCTestCase {
    var router: MockReportRouter!
    var view: MockReportView!
    var interactor: MockReportInteractor!
    var myProfileHolder: MyProfileHolder!
    var sut: ReportPresenter!
    
    override func setUp() {
        super.setUp()
        router = MockReportRouter()
        view = MockReportView()
        interactor = MockReportInteractor()
        myProfileHolder = MyProfileHolder()
        
        sut = ReportPresenter(myProfileHolder: myProfileHolder)
        sut.router = router
        sut.view = view
        sut.interactor = interactor
    }
    
    override func tearDown() {
        super.tearDown()
        router = nil
        view = nil
        interactor = nil
        myProfileHolder = nil
        sut = nil
    }
    
    func testThatItSetsInitialState() {
        // given
        
        // when
        sut.viewIsReady()
        
        // then
        XCTAssertTrue(view.setSubmitButtonEnabled_Called)
        XCTAssertEqual(view.setSubmitButtonEnabled_ReceivedIsEnabled, false)
    }
    
    func testThatItDoesNotSubmitReportWithoutSelectedRow() {
        // given
        
        // when
        sut.onSubmit()
        
        // then
        XCTAssertFalse(interactor.submitReport_with_completion_Called)
        XCTAssertFalse(view.setIsLoading_Called)
    }
    
    func testThatItSubmitsReportAndShowsReportSuccess() {
        // given
        let selectedRow = IndexPath(row: 0, section: 0)
        let reportReason = ReportReason.contentInfringement
        interactor.submitReport_with_completion_ReturnValue = .success()
        interactor.reportReason_forIndexPath_ReturnValue = reportReason
        
        // when
        sut.onRowSelected(at: selectedRow)
        sut.onSubmit()
        
        // then
        XCTAssertTrue(interactor.submitReport_with_completion_Called)
        XCTAssertEqual(interactor.submitReport_with_completion_ReceivedReason, reportReason)
        
        XCTAssertTrue(view.setIsLoading_Called)
        XCTAssertEqual(view.setIsLoading_ReceivedIsLoading, false)
        
        XCTAssertTrue(router.openReportSuccess_onDone_Called)
    }
    
    func testThatItShowsErrorWhenItFailsToSubmitReport() {
        // given
        let selectedRow = IndexPath(row: 0, section: 0)
        let error = APIError.unknown
        interactor.submitReport_with_completion_ReturnValue = .failure(error)
        interactor.reportReason_forIndexPath_ReturnValue = .contentInfringement
        
        // when
        sut.onRowSelected(at: selectedRow)
        sut.onSubmit()
        
        // then
        XCTAssertTrue(interactor.submitReport_with_completion_Called)
        
        XCTAssertTrue(view.setIsLoading_Called)
        XCTAssertEqual(view.setIsLoading_ReceivedIsLoading, false)
        XCTAssertTrue(view.showError_Called)
        
        guard let shownError = view.showError_ReceivedError as? APIError, case .unknown = shownError else {
            XCTFail("Error must be shown")
            return
        }
        
        XCTAssertFalse(router.openReportSuccess_onDone_Called)
    }
    
    func testThatItCancelsFlow() {
        sut.onCancel()
        XCTAssertTrue(router.close_Called)
    }
}
