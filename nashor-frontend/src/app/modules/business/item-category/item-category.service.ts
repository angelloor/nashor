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
import { itemCategory, itemCategorys } from './item-category.data';
import { ItemCategory } from './item-category.types';

@Injectable({
  providedIn: 'root',
})
export class ItemCategoryService {
  private _url: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _itemCategory: BehaviorSubject<ItemCategory> = new BehaviorSubject(
    itemCategory
  );
  private _itemCategorys: BehaviorSubject<ItemCategory[]> = new BehaviorSubject(
    itemCategorys
  );

  constructor(private _httpClient: HttpClient) {
    this._url = environment.urlBackend + '/app/business/item_category';
  }
  /**
   * Getter
   */
  get itemCategory$(): Observable<ItemCategory> {
    return this._itemCategory.asObservable();
  }
  /**
   * Getter for _itemCategorys
   */
  get itemCategorys$(): Observable<ItemCategory[]> {
    return this._itemCategorys.asObservable();
  }
  /**
   * create
   */
  create(id_user_: string, id_company: string): Observable<any> {
    return this._itemCategorys.pipe(
      take(1),
      switchMap((itemCategorys) =>
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
              const _itemCategory: ItemCategory = response.body;
              console.log(_itemCategory);
              /**
               * Update the itemCategory in the store
               */
              this._itemCategorys.next([_itemCategory, ...itemCategorys]);

              return of(_itemCategory);
            })
          )
      )
    );
  }
  /**
   * queryRead
   * @param query
   */
  queryRead(query: string): Observable<ItemCategory[]> {
    return this._httpClient
      .get<ItemCategory[]>(this._url + `/queryRead/${query ? query : '*'}`)
      .pipe(
        tap((itemCategorys: ItemCategory[]) => {
          if (itemCategorys) {
            this._itemCategorys.next(itemCategorys);
          } else {
            this._itemCategorys.next([]);
          }
        })
      );
  }
  /**
   * byCompanyQueryRead
   * @param id_company
   * @param query
   */
  byCompanyQueryRead(
    id_company: string,
    query: string
  ): Observable<ItemCategory[]> {
    return this._httpClient
      .get<ItemCategory[]>(
        this._url + `/byCompanyQueryRead/${id_company}/${query ? query : '*'}`
      )
      .pipe(
        tap((itemCategorys: ItemCategory[]) => {
          if (itemCategorys) {
            this._itemCategorys.next(itemCategorys);
          } else {
            this._itemCategorys.next([]);
          }
        })
      );
  }
  /**
   * specificRead
   * @param id_itemCategory
   */
  specificRead(id_itemCategory: string): Observable<ItemCategory> {
    return this._httpClient
      .get<ItemCategory>(this._url + `/specificRead/${id_itemCategory}`)
      .pipe(
        tap((itemCategory: ItemCategory) => {
          this._itemCategory.next(itemCategory);
          return itemCategorys;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(id_itemCategory: string): Observable<ItemCategory> {
    return this._itemCategorys.pipe(
      take(1),
      map((itemCategorys) => {
        /**
         * Find
         */
        const itemCategory =
          itemCategorys.find(
            (item) => item.id_item_category == id_itemCategory
          ) || null;
        /**
         * Update
         */
        this._itemCategory.next(itemCategory!);
        /**
         * Return
         */
        return itemCategory;
      }),
      switchMap((itemCategory) => {
        if (!itemCategory) {
          return throwError(
            () =>
              'No se encontro el elemento con el id ' + id_itemCategory + '!'
          );
        }
        return of(itemCategory);
      })
    );
  }
  /**
   * update
   * @param itemCategory
   */
  update(itemCategory: ItemCategory): Observable<any> {
    return this.itemCategorys$.pipe(
      take(1),
      switchMap((itemCategorys) =>
        this._httpClient
          .patch(this._url + '/update', itemCategory, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _itemCategory: ItemCategory = response.body;
              console.log(_itemCategory);
              /**
               * Find the index of the updated itemCategory
               */
              const index = itemCategorys.findIndex(
                (item) => item.id_item_category == itemCategory.id_item_category
              );
              console.log(index);
              /**
               * Update the itemCategory
               */
              itemCategorys[index] = _itemCategory;
              /**
               * Update the itemCategorys
               */
              this._itemCategorys.next(itemCategorys);

              /**
               * Update the itemCategory
               */
              this._itemCategory.next(_itemCategory);

              return of(_itemCategory);
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_item_category
   */
  delete(id_user_: string, id_item_category: string): Observable<any> {
    return this.itemCategorys$.pipe(
      take(1),
      switchMap((itemCategorys) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_item_category },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated itemCategory
                 */
                const index = itemCategorys.findIndex(
                  (item) => item.id_item_category == id_item_category
                );
                console.log(index);
                /**
                 * Delete the object of array
                 */
                itemCategorys.splice(index, 1);
                /**
                 * Update the itemCategorys
                 */
                this._itemCategorys.next(itemCategorys);
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
