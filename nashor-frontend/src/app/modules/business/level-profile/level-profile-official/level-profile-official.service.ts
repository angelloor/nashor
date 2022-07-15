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
import {
  levelProfileOfficial,
  levelProfileOfficials,
} from './level-profile-official.data';
import { LevelProfileOfficial } from './level-profile-official.types';

@Injectable({
  providedIn: 'root',
})
export class LevelProfileOfficialService {
  private _url: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _levelProfileOfficial: BehaviorSubject<LevelProfileOfficial> =
    new BehaviorSubject(levelProfileOfficial);
  private _levelProfileOfficials: BehaviorSubject<LevelProfileOfficial[]> =
    new BehaviorSubject(levelProfileOfficials);

  constructor(private _httpClient: HttpClient) {
    this._url = environment.urlBackend + '/app/business/level_profile_official';
  }
  /**
   * Getter
   */
  get levelProfileOfficial$(): Observable<LevelProfileOfficial> {
    return this._levelProfileOfficial.asObservable();
  }
  /**
   * Getter for _levelProfileOfficials
   */
  get levelProfileOfficials$(): Observable<LevelProfileOfficial[]> {
    return this._levelProfileOfficials.asObservable();
  }
  /**
   * create
   */
  create(id_user_: string, id_level_profile: string): Observable<any> {
    return this._levelProfileOfficials.pipe(
      take(1),
      switchMap((levelProfileOfficials) =>
        this._httpClient
          .post(
            this._url + '/create',
            {
              id_user_: parseInt(id_user_),
              level_profile: {
                id_level_profile: parseInt(id_level_profile),
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
              const _levelProfileOfficial: LevelProfileOfficial = response.body;
              /**
               * Update the levelProfileOfficial in the store
               */
              this._levelProfileOfficials.next([
                ...levelProfileOfficials,
                _levelProfileOfficial,
              ]);

              return of(_levelProfileOfficial);
            })
          )
      )
    );
  }
  /**
   * byLevelProfileRead
   * @param id_level_profile
   */
  byLevelProfileRead(
    id_level_profile: string
  ): Observable<LevelProfileOfficial[]> {
    return this._httpClient
      .get<LevelProfileOfficial[]>(
        this._url + `/byLevelProfileRead/${id_level_profile}`
      )
      .pipe(
        tap((levelProfileOfficials: LevelProfileOfficial[]) => {
          if (levelProfileOfficials) {
            this._levelProfileOfficials.next(levelProfileOfficials);
          } else {
            this._levelProfileOfficials.next([]);
          }
        })
      );
  }
  /**
   * specificRead
   * @param id_levelProfileOfficial
   */
  specificRead(
    id_levelProfileOfficial: string
  ): Observable<LevelProfileOfficial> {
    return this._httpClient
      .get<LevelProfileOfficial>(
        this._url + `/specificRead/${id_levelProfileOfficial}`
      )
      .pipe(
        tap((levelProfileOfficial: LevelProfileOfficial) => {
          this._levelProfileOfficial.next(levelProfileOfficial);
          return levelProfileOfficials;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(
    id_levelProfileOfficial: string
  ): Observable<LevelProfileOfficial> {
    return this._levelProfileOfficials.pipe(
      take(1),
      map((levelProfileOfficials) => {
        /**
         * Find
         */
        const levelProfileOfficial =
          levelProfileOfficials.find(
            (item) => item.id_level_profile_official == id_levelProfileOfficial
          ) || null;
        /**
         * Update
         */
        this._levelProfileOfficial.next(levelProfileOfficial!);
        /**
         * Return
         */
        return levelProfileOfficial;
      }),
      switchMap((levelProfileOfficial) => {
        if (!levelProfileOfficial) {
          return throwError(
            () =>
              'No se encontro el elemento con el id ' +
              id_levelProfileOfficial +
              '!'
          );
        }
        return of(levelProfileOfficial);
      })
    );
  }
  /**
   * update
   * @param levelProfileOfficial
   */
  update(levelProfileOfficial: LevelProfileOfficial): Observable<any> {
    return this.levelProfileOfficials$.pipe(
      take(1),
      switchMap((levelProfileOfficials) =>
        this._httpClient
          .patch(this._url + '/update', levelProfileOfficial, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _levelProfileOfficial: LevelProfileOfficial = response.body;
              /**
               * Find the index of the updated levelProfileOfficial
               */
              const index = levelProfileOfficials.findIndex(
                (item) =>
                  item.id_level_profile_official ==
                  levelProfileOfficial.id_level_profile_official
              );
              /**
               * Update the levelProfileOfficial
               */
              levelProfileOfficials[index] = _levelProfileOfficial;
              /**
               * Update the levelProfileOfficials
               */
              this._levelProfileOfficials.next(levelProfileOfficials);

              /**
               * Update the levelProfileOfficial
               */
              this._levelProfileOfficial.next(_levelProfileOfficial);

              return of(_levelProfileOfficial);
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_level_profile_official
   */
  delete(id_user_: string, id_level_profile_official: string): Observable<any> {
    return this.levelProfileOfficials$.pipe(
      take(1),
      switchMap((levelProfileOfficials) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_level_profile_official },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated levelProfileOfficial
                 */
                const index = levelProfileOfficials.findIndex(
                  (item) =>
                    item.id_level_profile_official == id_level_profile_official
                );
                /**
                 * Delete the object of array
                 */
                levelProfileOfficials.splice(index, 1);
                /**
                 * Update the levelProfileOfficials
                 */
                this._levelProfileOfficials.next(levelProfileOfficials);
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
