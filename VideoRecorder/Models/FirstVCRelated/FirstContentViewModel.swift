//
//  ContentViewModel.swift
//  VideoRecorder
//
//  Created by pablo.jee on 2022/10/11.
//

import Foundation

class FirstContentViewModel {
    
    //input
    var didReceiveData: ([VideoCellContentViewModel]) -> () = { cellViewModel in  }
    
    var didReceiveViewMoreEvent: () -> () = { }
    
    var didReceiveDeleteVideoEvent: (Int) -> () = { indexPathRow in  } //테이블뷰 셀 스와이프 딜리트 액션
    
    var didReceiveDeleteRowEvent: (Int) -> () = { indexPathRow in  }
    
    //output
    
    var propergateViewMoreEvent: () -> () = { }
    
    var propergateDeleteVideoEvent: (Int) -> () = { indexPathRow in } //Model로 셀 지우는 이벤트가 호출되었음을 전파
    
    var propergateDeleteRowEvent: (Int) -> () = { indexPathRow in }
    
    var dataSource: [VideoCellContentViewModel] {
        return _dataSource
    }
    
    //properties
    @MainThreadActor var propergateData: ( (()) -> () )?
    
    private var _dataSource: [VideoCellContentViewModel]
    
    
    
    init() {
        self._dataSource = []
        bind()
    }
    
    private func bind() {
        didReceiveData = { [weak self] cellViewModel in
            guard let self = self else { return }
            self._dataSource = self._dataSource + cellViewModel
            self.propergateData?(())
        }
        
        didReceiveViewMoreEvent = { [weak self] in
            guard let self = self else { return }
            print("didReceiveViewMoreEvent")
            self.propergateViewMoreEvent()
        }
        
        didReceiveDeleteVideoEvent = { [weak self] indexPathRow in
            guard let self = self else { return }
            self.findDataSourceWithIndexPathRow(indexPathRow)
        }
        
        didReceiveDeleteRowEvent = { [weak self] indexPathRow in
            guard let self = self else { return }
            _ = self._dataSource.remove(at: indexPathRow)
            self.propergateDeleteRowEvent(indexPathRow)
        }
    }
    
    private func findDataSourceWithIndexPathRow (_ row: Int) {
        // TODO: 지워야 할 row 찾고 URL 리턴...?
        propergateDeleteVideoEvent(row)
    }
}
