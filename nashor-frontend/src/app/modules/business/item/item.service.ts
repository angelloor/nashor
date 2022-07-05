import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from 'environments/environment';
import {
  BehaviorSubject,
  map,
  Observable,
  of,
  switchMap,
  take,
  tap,
  throwError,
} from 'rxjs';
import { item, items } from './item.data';
import { Item } from './item.types';

@Injectable({
  providedIn: 'root',
})
export class ItemService {
  private _url: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _item: BehaviorSubject<Item> = new BehaviorSubject(item);
  private _items: BehaviorSubject<Item[]> = new BehaviorSubject(items);

  constructor(private _httpClient: HttpClient) {
    this._url = environment.urlBackend + '/app/business/item';
  }
  /**
   * Getter
   */
  get item$(): Observable<Item> {
    return this._item.asObservable();
  }
  /**
   * Getter for _items
   */
  get items$(): Observable<Item[]> {
    return this._items.asObservable();
  }
  /**
   * create
   */
  create(id_user_: string, id_company: string): Observable<any> {
    return this._items.pipe(
      take(1),
      switchMap((items) =>
        this._httpClient
          .post(
            this._url + '/create',
            {
              id_user_: parseInt(id_user_),
              company: {
                id_company: parseInt(id_company),
              },
            },
            {
              headers: this._headers,
            }
          )
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _item: Item = response.body;
              console.log(_item);
              /**
               * Update the item in the store
               */
              this._items.next([_item, ...items]);

              return of(_item);
            })
          )
      )
    );
  }
  /**
   * queryRead
   * @param query
   */
  queryRead(query: string): Observable<Item[]> {
    return this._httpClient
      .get<Item[]>(this._url + `/queryRead/${query ? query : '*'}`)
      .pipe(
        tap((items: Item[]) => {
          if (items) {
            this._items.next(items);
          } else {
            this._items.next([]);
          }
        })
      );
  }
  /**
   * byCompanyQueryRead
   * @param id_company
   * @param query
   */
  byCompanyQueryRead(id_company: string, query: string): Observable<Item[]> {
    return this._httpClient
      .get<Item[]>(
        this._url + `/byCompanyQueryRead/${id_company}/${query ? query : '*'}`
      )
      .pipe(
        tap((items: Item[]) => {
          if (items) {
            this._items.next(items);
          } else {
            this._items.next([]);
          }
        })
      );
  }
  /**
   * byItemCategoryQueryRead
   * @param id_item_category
   * @param query
   */
  byItemCategoryQueryRead(
    id_item_category: string,
    query: string
  ): Observable<Item[]> {
    return this._httpClient
      .get<Item[]>(
        this._url +
          `/byItemCategoryQueryRead/${id_item_category}/${query ? query : '*'}`
      )
      .pipe(
        tap((items: Item[]) => {
          if (items) {
            this._items.next(items);
          } else {
            this._items.next([]);
          }
        })
      );
  }
  /**
   * specificRead
   * @param id_item
   */
  specificRead(id_item: string): Observable<Item> {
    return this._httpClient
      .get<Item>(this._url + `/specificRead/${id_item}`)
      .pipe(
        tap((item: Item) => {
          this._item.next(item);
          return items;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(id_item: string): Observable<Item> {
    return this._items.pipe(
      take(1),
      map((items) => {
        /**
         * Find
         */
        const item = items.find((item) => item.id_item == id_item) || null;
        /**
         * Update
         */
        this._item.next(item!);
        /**
         * Return
         */
        return item;
      }),
      switchMap((item) => {
        if (!item) {
          return throwError(
            () => 'No se encontro el elemento con el id ' + id_item + '!'
          );
        }
        return of(item);
      })
    );
  }
  /**
   * update
   * @param item
   */
  update(item: Item): Observable<any> {
    return this.items$.pipe(
      take(1),
      switchMap((items) =>
        this._httpClient
          .patch(this._url + '/update', item, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _item: Item = response.body;
              console.log(_item);
              /**
               * Find the index of the updated item
               */
              const index = items.findIndex(
                (item) => item.id_item == item.id_item
              );
              console.log(index);
              /**
               * Update the item
               */
              items[index] = _item;
              /**
               * Update the items
               */
              this._items.next(items);

              /**
               * Update the item
               */
              this._item.next(_item);

              return of(_item);
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_item
   */
  delete(id_user_: string, id_item: string): Observable<any> {
    return this.items$.pipe(
      take(1),
      switchMap((items) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_item },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated item
                 */
                const index = items.findIndex(
                  (item) => item.id_item == id_item
                );
                console.log(index);
                /**
                 * Delete the object of array
                 */
                items.splice(index, 1);
                /**
                 * Update the items
                 */
                this._items.next(items);
                return of(response.body);
              } else {
                return of(false);
              }
            })
          )
      )
    );
  }
}
