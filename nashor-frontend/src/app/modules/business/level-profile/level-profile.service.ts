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
import { levelProfile, levelProfiles } from './level-profile.data';
import { LevelProfile } from './level-profile.types';

@Injectable({
  providedIn: 'root',
})
export class LevelProfileService {
  private _url: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _levelProfile: BehaviorSubject<LevelProfile> = new BehaviorSubject(
    levelProfile
  );
  private _levelProfiles: BehaviorSubject<LevelProfile[]> = new BehaviorSubject(
    levelProfiles
  );

  constructor(private _httpClient: HttpClient) {
    this._url = environment.urlBackend + '/app/business/level_profile';
  }
  /**
   * Getter
   */
  get levelProfile$(): Observable<LevelProfile> {
    return this._levelProfile.asObservable();
  }
  /**
   * Getter for _levelProfiles
   */
  get levelProfiles$(): Observable<LevelProfile[]> {
    return this._levelProfiles.asObservable();
  }
  /**
   * create
   */
  create(id_user_: string, id_company: string): Observable<any> {
    return this._levelProfiles.pipe(
      take(1),
      switchMap((levelProfiles) =>
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
              const _levelProfile: LevelProfile = response.body;
              /**
               * Update the levelProfile in the store
               */
              this._levelProfiles.next([_levelProfile, ...levelProfiles]);

              return of(_levelProfile);
            })
          )
      )
    );
  }
  /**
   * queryRead
   * @param query
   */
  queryRead(query: string): Observable<LevelProfile[]> {
    return this._httpClient
      .get<LevelProfile[]>(this._url + `/queryRead/${query ? query : '*'}`)
      .pipe(
        tap((levelProfiles: LevelProfile[]) => {
          if (levelProfiles) {
            this._levelProfiles.next(levelProfiles);
          } else {
            this._levelProfiles.next([]);
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
  ): Observable<LevelProfile[]> {
    return this._httpClient
      .get<LevelProfile[]>(
        this._url + `/byCompanyQueryRead/${id_company}/${query ? query : '*'}`
      )
      .pipe(
        tap((levelProfiles: LevelProfile[]) => {
          if (levelProfiles) {
            this._levelProfiles.next(levelProfiles);
          } else {
            this._levelProfiles.next([]);
          }
        })
      );
  }
  /**
   * specificRead
   * @param id_levelProfile
   */
  specificRead(id_levelProfile: string): Observable<LevelProfile> {
    return this._httpClient
      .get<LevelProfile>(this._url + `/specificRead/${id_levelProfile}`)
      .pipe(
        tap((levelProfile: LevelProfile) => {
          this._levelProfile.next(levelProfile);
          return levelProfiles;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(id_levelProfile: string): Observable<LevelProfile> {
    return this._levelProfiles.pipe(
      take(1),
      map((levelProfiles) => {
        /**
         * Find
         */
        const levelProfile =
          levelProfiles.find(
            (item) => item.id_level_profile == id_levelProfile
          ) || null;
        /**
         * Update
         */
        this._levelProfile.next(levelProfile!);
        /**
         * Return
         */
        return levelProfile;
      }),
      switchMap((levelProfile) => {
        if (!levelProfile) {
          return throwError(
            () =>
              'No se encontro el elemento con el id ' + id_levelProfile + '!'
          );
        }
        return of(levelProfile);
      })
    );
  }
  /**
   * update
   * @param levelProfile
   */
  update(levelProfile: LevelProfile): Observable<any> {
    return this.levelProfiles$.pipe(
      take(1),
      switchMap((levelProfiles) =>
        this._httpClient
          .patch(this._url + '/update', levelProfile, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _levelProfile: LevelProfile = response.body;
              /**
               * Find the index of the updated levelProfile
               */
              const index = levelProfiles.findIndex(
                (item) => item.id_level_profile == levelProfile.id_level_profile
              );
              /**
               * Update the levelProfile
               */
              levelProfiles[index] = _levelProfile;
              /**
               * Update the levelProfiles
               */
              this._levelProfiles.next(levelProfiles);

              /**
               * Update the levelProfile
               */
              this._levelProfile.next(_levelProfile);

              return of(_levelProfile);
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_level_profile
   */
  delete(id_user_: string, id_level_profile: string): Observable<any> {
    return this.levelProfiles$.pipe(
      take(1),
      switchMap((levelProfiles) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_level_profile },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated levelProfile
                 */
                const index = levelProfiles.findIndex(
                  (item) => item.id_level_profile == id_level_profile
                );
                /**
                 * Delete the object of array
                 */
                levelProfiles.splice(index, 1);
                /**
                 * Update the levelProfiles
                 */
                this._levelProfiles.next(levelProfiles);
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
