//
//  PersistenceManager.swift
//  ShowFlixUIKit
//
//  Created by mac 2019 on 1/4/24.
//

import CoreData

extension WatchListItem{
    static func from(_ show: Show, context: NSManagedObjectContext) -> WatchListItem{
        let item = WatchListItem(context: context)
        item.showId = Int64(show.id)
        item.mediaType = show.media_type
        item.originalTitle = show.original_title
        item.originalName = show.original_name
        item.details = show.overview
        item.posterPath = show.poster_path
        
        return item
    }
    
    static func toShow(from watchListItem: WatchListItem)-> Show{
        let show = Show(
            id: Int(watchListItem.showId), 
            media_type: watchListItem.mediaType,
            original_name: watchListItem.originalName,
            original_title: watchListItem.originalTitle,
            poster_path: watchListItem.posterPath,
            overview: watchListItem.details,
            vote_count: 0, 
            release_date: nil,
            vote_average: 0
        )
        return show
    }
}

enum DBError: Error{
    case saveError, fetchError, deleteError
}

class PersistenceManager{
    static let notificationId = "PersistenceManager"
    
    static let shared: PersistenceManager = PersistenceManager()
    private init(){
        getWatchListItems { _ in }
    }
    
    private var watchListItems: [WatchListItem]?
    
    var watchListedShows: [Show]{
        watchListItems?.map{ WatchListItem.toShow(from: $0)} ?? []
    }
    
    private func getWatchListItems(completion: @escaping ((Result<[Show], DBError>) -> Void)){
        
        if let watchListItems{
            completion(.success(watchListItems.map{ WatchListItem.toShow(from: $0)}))
            return
        }
        do {
            let request: NSFetchRequest<WatchListItem> = WatchListItem.fetchRequest()
            self.watchListItems = try context.fetch(request)
            
            let shows = self.watchListItems?.map{ WatchListItem.toShow(from: $0) } ?? []
            
            completion(.success(shows))
            NotificationCenter.default.post(name: NSNotification.Name(PersistenceManager.notificationId), object: nil)
        } catch {
            completion(.failure(.fetchError))
        }
    }
    func addToWatchList(show: Show, completion: @escaping ((Result<Void, DBError>) -> Void)){
        
        guard !isAddedToWatchList(show: show) else {
            completion(.success(()))
            return
        }
        
        do {
            let watchListItem = WatchListItem.from(show, context: context)
            try context.save()
            watchListItems?.append(watchListItem)
            completion(.success(()))
            NotificationCenter.default.post(name: NSNotification.Name(PersistenceManager.notificationId), object: nil)
        } catch {
            completion(.failure(.saveError))
        }
        
    }
    func removeFromWatchList(show: Show, completion: @escaping ((Result<Void, DBError>) -> Void)){
        
        guard let existingItem = watchListItems?.first(where: {$0.showId == show.id}) else {
            completion(.success(()))
            return
        }
        
        do {
            context.delete(existingItem)
            try context.save()
            watchListItems?.removeAll{ $0 == existingItem }
            completion(.success(()))
            NotificationCenter.default.post(name: NSNotification.Name(PersistenceManager.notificationId), object: nil)
        } catch {
            completion(.failure(.deleteError))
        }
    }
    
    func isAddedToWatchList(show: Show) -> Bool{
        watchListItems?.contains{ $0.showId == show.id } ?? false
    }
    
    // MARK: - Core Data stack

    private var context: NSManagedObjectContext{
        persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = { // persistent container
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () { // context manager
        let context = context
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
