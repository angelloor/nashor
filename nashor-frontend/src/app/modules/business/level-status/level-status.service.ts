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
import { levelStatus, levelStatuss } from './level-status.data';
import { LevelStatus } from './level-status.types';

@Injectable({
  providedIn: 'root',
})
export class LevelStatusService {
  private _url: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _levelStatus: BehaviorSubject<LevelStatus> = new BehaviorSubject(
    levelStatus
  );
  private _levelStatuss: BehaviorSubject<LevelStatus[]> = new BehaviorSubject(
    levelStatuss
  );

  constructor(private _httpClient: HttpClient) {
    this._url = environment.urlBackend + '/app/business/level_status';
  }
  /**
   * Getter
   */
  get levelStatus$(): Observable<LevelStatus> {
    return this._levelStatus.asObservable();
  }
  /**
   * Getter for _levelStatuss
   */
  get levelStatuss$(): Observable<LevelStatus[]> {
    return this._levelStatuss.asObservable();
  }
  /**
   * create
   */
  create(id_user_: string, id_company: string): Observable<any> {
    return this._levelStatuss.pipe(
      take(1),
      switchMap((levelStatuss) =>
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
              const _levelStatus: LevelStatus = response.body;
              console.log(_levelStatus);
              /**
               * Update the levelStatus in the store
               */
              this._levelStatuss.next([_levelStatus, ...levelStatuss]);

              return of(_levelStatus);
            })
          )
      )
    );
  }
  /**
   * queryRead
   * @param query
   */
  queryRead(query: string): Observable<LevelStatus[]> {
    return this._httpClient
      .get<LevelStatus[]>(this._url + `/queryRead/${query ? query : '*'}`)
      .pipe(
        tap((levelStatuss: LevelStatus[]) => {
          if (levelStatuss) {
            this._levelStatuss.next(levelStatuss);
          } else {
            this._levelStatuss.next([]);
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
  ): Observable<LevelStatus[]> {
    return this._httpClient
      .get<LevelStatus[]>(
        this._url + `/byCompanyQueryRead/${id_company}/${query ? query : '*'}`
      )
      .pipe(
        tap((levelStatuss: LevelStatus[]) => {
          if (levelStatuss) {
            this._levelStatuss.next(levelStatuss);
          } else {
            this._levelStatuss.next([]);
          }
        })
      );
  }
  /**
   * specificRead
   * @param id_levelStatus
   */
  specificRead(id_levelStatus: string): Observable<LevelStatus> {
    return this._httpClient
      .get<LevelStatus>(this._url + `/specificRead/${id_levelStatus}`)
      .pipe(
        tap((levelStatus: LevelStatus) => {
          this._levelStatus.next(levelStatus);
          return levelStatuss;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(id_levelStatus: string): Observable<LevelStatus> {
    return this._levelStatuss.pipe(
      take(1),
      map((levelStatuss) => {
        /**
         * Find
         */
        const levelStatus =
          levelStatuss.find((item) => item.id_level_status == id_levelStatus) ||
          null;
        /**
         * Update
         */
        this._levelStatus.next(levelStatus!);
        /**
         * Return
         */
        return levelStatus;
      }),
      switchMap((levelStatus) => {
        if (!levelStatus) {
          return throwError(
            () => 'No se encontro el elemento con el id ' + id_levelStatus + '!'
          );
        }
        return of(levelStatus);
      })
    );
  }
  /**
   * update
   * @param levelStatus
   */
  update(levelStatus: LevelStatus): Observable<any> {
    return this.levelStatuss$.pipe(
      take(1),
      switchMap((levelStatuss) =>
        this._httpClient
          .patch(this._url + '/update', levelStatus, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _levelStatus: LevelStatus = response.body;
              console.log(_levelStatus);
              /**
               * Find the index of the updated levelStatus
               */
              const index = levelStatuss.findIndex(
                (item) => item.id_level_status == levelStatus.id_level_status
              );
              console.log(index);
              /**
               * Update the levelStatus
               */
              levelStatuss[index] = _levelStatus;
              /**
               * Update the levelStatuss
               */
              this._levelStatuss.next(levelStatuss);

              /**
               * Update the levelStatus
               */
              this._levelStatus.next(_levelStatus);

              return of(_levelStatus);
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_level_status
   */
  delete(id_user_: string, id_level_status: string): Observable<any> {
    return this.levelStatuss$.pipe(
      take(1),
      switchMap((levelStatuss) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_level_status },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated levelStatus
                 */
                const index = levelStatuss.findIndex(
                  (item) => item.id_level_status == id_level_status
                );
                console.log(index);
                /**
                 * Delete the object of array
                 */
                levelStatuss.splice(index, 1);
                /**
                 * Update the levelStatuss
                 */
                this._levelStatuss.next(levelStatuss);
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
