import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Store } from '@ngrx/store';
import { AppInitialData } from 'app/core/app/app.type';
import { User } from 'app/modules/core/user/user.types';
import { updateAvatar } from 'app/store/global/global.actions';
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
import { official, officials } from './official.data';
import { Official } from './official.types';

@Injectable({
  providedIn: 'root',
})
export class OfficialService {
  private _url: string;
  private _urlUser: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _official: BehaviorSubject<Official> = new BehaviorSubject(official);
  private _officials: BehaviorSubject<Official[]> = new BehaviorSubject(
    officials
  );

  constructor(
    private _httpClient: HttpClient,
    private _store: Store<{ global: AppInitialData }>
  ) {
    this._url = environment.urlBackend + '/app/business/official';
    this._urlUser = environment.urlBackend + '/app/core/user';
  }
  /**
   * Getter
   */
  get official$(): Observable<Official> {
    return this._official.asObservable();
  }
  /**
   * Getter for _officials
   */
  get officials$(): Observable<Official[]> {
    return this._officials.asObservable();
  }
  /**
   * create
   */
  create(id_user_: string, id_company: string): Observable<any> {
    return this._officials.pipe(
      take(1),
      switchMap((officials) =>
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
              const _official: Official = response.body;
              /**
               * Update the official in the store
               */
              this._officials.next([_official, ...officials]);

              return of(_official);
            })
          )
      )
    );
  }
  /**
   * queryRead
   * @param query
   */
  queryRead(query: string): Observable<Official[]> {
    return this._httpClient
      .get<Official[]>(this._url + `/queryRead/${query ? query : '*'}`)
      .pipe(
        tap((officials: Official[]) => {
          if (officials) {
            this._officials.next(officials);
          } else {
            this._officials.next([]);
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
  ): Observable<Official[]> {
    return this._httpClient
      .get<Official[]>(
        this._url + `/byCompanyQueryRead/${id_company}/${query ? query : '*'}`
      )
      .pipe(
        tap((officials: Official[]) => {
          if (officials) {
            this._officials.next(officials);
          } else {
            this._officials.next([]);
          }
        })
      );
  }
  /**
   * byAreaQueryRead
   * @param id_area
   * @param query
   */
  byAreaQueryRead(id_area: string, query: string): Observable<Official[]> {
    return this._httpClient
      .get<Official[]>(
        this._url + `/byAreaQueryRead/${id_area}/${query ? query : '*'}`
      )
      .pipe(
        tap((officials: Official[]) => {
          if (officials) {
            this._officials.next(officials);
          } else {
            this._officials.next([]);
          }
        })
      );
  }
  /**
   * byPositionQueryRead
   * @param id_position
   * @param query
   */
  byPositionQueryRead(
    id_position: string,
    query: string
  ): Observable<Official[]> {
    return this._httpClient
      .get<Official[]>(
        this._url + `/byPositionQueryRead/${id_position}/${query ? query : '*'}`
      )
      .pipe(
        tap((officials: Official[]) => {
          if (officials) {
            this._officials.next(officials);
          } else {
            this._officials.next([]);
          }
        })
      );
  }
  /**
   * specificRead
   * @param id_official
   */
  specificRead(id_official: string): Observable<Official> {
    return this._httpClient
      .get<Official>(this._url + `/specificRead/${id_official}`)
      .pipe(
        tap((official: Official) => {
          this._official.next(official);
          return officials;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(id_official: string): Observable<Official> {
    return this._officials.pipe(
      take(1),
      map((officials) => {
        /**
         * Find
         */
        const official =
          officials.find((item) => item.id_official == id_official) || null;
        /**
         * Update
         */
        this._official.next(official!);
        /**
         * Return
         */
        return official;
      }),
      switchMap((official) => {
        if (!official) {
          return throwError(
            () => 'No se encontro el elemento con el id ' + id_official + '!'
          );
        }
        return of(official);
      })
    );
  }
  /**
   * update
   * @param official
   */
  update(official: Official): Observable<any> {
    return this.officials$.pipe(
      take(1),
      switchMap((officials) =>
        this._httpClient
          .patch(this._url + '/update', official, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _official: Official = response.body;
              /**
               * Find the index of the updated official
               */
              const index = officials.findIndex(
                (item) => item.id_official == official.id_official
              );
              /**
               * Update the official
               */
              officials[index] = _official;
              /**
               * Update the officials
               */
              this._officials.next(officials);

              /**
               * Update the official
               */
              this._official.next(_official);

              return of(_official);
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_official
   */
  delete(id_user_: string, id_official: string): Observable<any> {
    return this.officials$.pipe(
      take(1),
      switchMap((officials) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_official },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated official
                 */
                const index = officials.findIndex(
                  (item) => item.id_official == id_official
                );
                /**
                 * Delete the object of array
                 */
                officials.splice(index, 1);
                /**
                 * Update the officials
                 */
                this._officials.next(officials);
                return of(response.body);
              } else {
                return of(false);
              }
            })
          )
      )
    );
  }
  /**
   * Update avatar
   */
  uploadAvatar(
    user: User,
    avatar: File,
    UserLoggedIn: User
  ): Observable<boolean> {
    var formData = new FormData();

    formData.append('avatar', avatar);
    formData.append('id_user', user.id_user);

    return this.officials$.pipe(
      take(1),
      switchMap((officials) =>
        this._httpClient.post(this._urlUser + '/uploadAvatar', formData).pipe(
          switchMap((response: any) => {
            const avatar_user: string = response.body.new_path;

            const index = officials.findIndex(
              (official) => official.user.id_user === user.id_user
            );

            officials[index] = {
              ...officials[index],
              user: {
                ...officials[index].user,
                avatar_user,
              },
            };

            this._officials.next(officials);
            this._official.next({
              ...officials[index],
              user: {
                ...officials[index].user,
                avatar_user,
              },
            });

            if (user.id_user == UserLoggedIn.id_user) {
              // Update the avatar in the store
              this._store.dispatch(
                updateAvatar({
                  ...user,
                  avatar_user,
                })
              );
            }

            return of(true);
          })
        )
      )
    );
  }
  /**
   * removeAvatar
   */
  removeAvatar(user: User, UserLoggedIn: User): Observable<boolean> {
    return this.officials$.pipe(
      take(1),
      switchMap((officials) =>
        this._httpClient
          .post(this._urlUser + '/removeAvatar', { id_user: user.id_user })
          .pipe(
            switchMap(() => {
              const index = officials.findIndex(
                (official) => official.user.id_user === user.id_user
              );

              officials[index] = {
                ...officials[index],
                user: {
                  ...officials[index].user,
                  avatar_user: 'default.svg',
                },
              };

              this._officials.next(officials);
              this._official.next({
                ...officials[index],
                user: {
                  ...officials[index].user,
                  avatar_user: 'default.svg',
                },
              });

              if (user.id_user == UserLoggedIn.id_user) {
                // Update the avatar in the store
                this._store.dispatch(
                  updateAvatar({
                    ...user,
                    avatar_user: 'default.svg',
                  })
                );
              }

              return of(true);
            })
          )
      )
    );
  }
}
