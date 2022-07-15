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
import { position, positions } from './position.data';
import { Position } from './position.types';

@Injectable({
  providedIn: 'root',
})
export class PositionService {
  private _url: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _position: BehaviorSubject<Position> = new BehaviorSubject(position);
  private _positions: BehaviorSubject<Position[]> = new BehaviorSubject(
    positions
  );

  constructor(private _httpClient: HttpClient) {
    this._url = environment.urlBackend + '/app/business/position';
  }
  /**
   * Getter
   */
  get position$(): Observable<Position> {
    return this._position.asObservable();
  }
  /**
   * Getter for _positions
   */
  get positions$(): Observable<Position[]> {
    return this._positions.asObservable();
  }
  /**
   * create
   */
  create(id_user_: string, id_company: string): Observable<any> {
    return this._positions.pipe(
      take(1),
      switchMap((positions) =>
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
              const _position: Position = response.body;
              /**
               * Update the position in the store
               */
              this._positions.next([_position, ...positions]);

              return of(_position);
            })
          )
      )
    );
  }
  /**
   * queryRead
   * @param query
   */
  queryRead(query: string): Observable<Position[]> {
    return this._httpClient
      .get<Position[]>(this._url + `/queryRead/${query ? query : '*'}`)
      .pipe(
        tap((positions: Position[]) => {
          if (positions) {
            this._positions.next(positions);
          } else {
            this._positions.next([]);
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
  ): Observable<Position[]> {
    return this._httpClient
      .get<Position[]>(
        this._url + `/byCompanyQueryRead/${id_company}/${query ? query : '*'}`
      )
      .pipe(
        tap((positions: Position[]) => {
          if (positions) {
            this._positions.next(positions);
          } else {
            this._positions.next([]);
          }
        })
      );
  }
  /**
   * specificRead
   * @param id_position
   */
  specificRead(id_position: string): Observable<Position> {
    return this._httpClient
      .get<Position>(this._url + `/specificRead/${id_position}`)
      .pipe(
        tap((position: Position) => {
          this._position.next(position);
          return positions;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(id_position: string): Observable<Position> {
    return this._positions.pipe(
      take(1),
      map((positions) => {
        /**
         * Find
         */
        const position =
          positions.find((item) => item.id_position == id_position) || null;
        /**
         * Update
         */
        this._position.next(position!);
        /**
         * Return
         */
        return position;
      }),
      switchMap((position) => {
        if (!position) {
          return throwError(
            () => 'No se encontro el elemento con el id ' + id_position + '!'
          );
        }
        return of(position);
      })
    );
  }
  /**
   * update
   * @param position
   */
  update(position: Position): Observable<any> {
    return this.positions$.pipe(
      take(1),
      switchMap((positions) =>
        this._httpClient
          .patch(this._url + '/update', position, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _position: Position = response.body;
              /**
               * Find the index of the updated position
               */
              const index = positions.findIndex(
                (item) => item.id_position == position.id_position
              );
              /**
               * Update the position
               */
              positions[index] = _position;
              /**
               * Update the positions
               */
              this._positions.next(positions);

              /**
               * Update the position
               */
              this._position.next(_position);

              return of(_position);
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_position
   */
  delete(id_user_: string, id_position: string): Observable<any> {
    return this.positions$.pipe(
      take(1),
      switchMap((positions) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_position },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated position
                 */
                const index = positions.findIndex(
                  (item) => item.id_position == id_position
                );
                /**
                 * Delete the object of array
                 */
                positions.splice(index, 1);
                /**
                 * Update the positions
                 */
                this._positions.next(positions);
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
