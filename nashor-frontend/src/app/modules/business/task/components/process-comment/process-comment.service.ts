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
import { processComment, processComments } from './process-comment.data';
import { ProcessComment } from './process-comment.types';

@Injectable({
  providedIn: 'root',
})
export class ProcessCommentService {
  private _url: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _processComment: BehaviorSubject<ProcessComment> =
    new BehaviorSubject(processComment);
  private _processComments: BehaviorSubject<ProcessComment[]> =
    new BehaviorSubject(processComments);

  constructor(private _httpClient: HttpClient) {
    this._url = environment.urlBackend + '/app/business/process_comment';
  }
  /**
   * Getter
   */
  get processComment$(): Observable<ProcessComment> {
    return this._processComment.asObservable();
  }
  /**
   * Getter for _processComments
   */
  get processComments$(): Observable<ProcessComment[]> {
    return this._processComments.asObservable();
  }
  /**
   * create
   */
  create(
    id_user_: string,
    id_official: string,
    id_process: string,
    id_task: string,
    id_level: string
  ): Observable<any> {
    return this._processComments.pipe(
      take(1),
      switchMap((processComments) =>
        this._httpClient
          .post(
            this._url + '/create',
            {
              id_user_: parseInt(id_user_),
              official: {
                id_official: parseInt(id_official),
              },
              process: {
                id_process: parseInt(id_process),
              },
              task: {
                id_task: parseInt(id_task),
              },
              level: {
                id_level: parseInt(id_level),
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
              const _processComment: ProcessComment = response.body;
              /**
               * Update the processComment in the store
               */
              this._processComments.next([_processComment, ...processComments]);

              return of(_processComment);
            })
          )
      )
    );
  }
  /**
   * byOfficialRead
   * @param id_official
   */
  byOfficialRead(id_official: string): Observable<ProcessComment[]> {
    return this._httpClient
      .get<ProcessComment[]>(this._url + `/byOfficialRead/${id_official}`)
      .pipe(
        tap((processComments: ProcessComment[]) => {
          if (processComments) {
            this._processComments.next(processComments);
          } else {
            this._processComments.next([]);
          }
        })
      );
  }
  /**
   * byProcessRead
   * @param id_process
   */
  byProcessRead(id_process: string): Observable<ProcessComment[]> {
    return this._httpClient
      .get<ProcessComment[]>(this._url + `/byProcessRead/${id_process}`)
      .pipe(
        tap((processComments: ProcessComment[]) => {
          if (processComments) {
            this._processComments.next(processComments);
          } else {
            this._processComments.next([]);
          }
        })
      );
  }
  /**
   * byTaskRead
   * @param id_task
   */
  byTaskRead(id_task: string): Observable<ProcessComment[]> {
    return this._httpClient
      .get<ProcessComment[]>(this._url + `/byTaskRead/${id_task}`)
      .pipe(
        tap((processComments: ProcessComment[]) => {
          if (processComments) {
            this._processComments.next(processComments);
          } else {
            this._processComments.next([]);
          }
        })
      );
  }
  /**
   * byLevelRead
   * @param id_level
   */
  byLevelRead(id_level: string): Observable<ProcessComment[]> {
    return this._httpClient
      .get<ProcessComment[]>(this._url + `/byLevelRead/${id_level}`)
      .pipe(
        tap((processComments: ProcessComment[]) => {
          if (processComments) {
            this._processComments.next(processComments);
          } else {
            this._processComments.next([]);
          }
        })
      );
  }
  /**
   * specificRead
   * @param id_processComment
   */
  specificRead(id_processComment: string): Observable<ProcessComment> {
    return this._httpClient
      .get<ProcessComment>(this._url + `/specificRead/${id_processComment}`)
      .pipe(
        tap((processComment: ProcessComment) => {
          this._processComment.next(processComment);
          return processComments;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(id_processComment: string): Observable<ProcessComment> {
    return this._processComments.pipe(
      take(1),
      map((processComments) => {
        /**
         * Find
         */
        const processComment =
          processComments.find(
            (item) => item.id_process_comment == id_processComment
          ) || null;
        /**
         * Update
         */
        this._processComment.next(processComment!);
        /**
         * Return
         */
        return processComment;
      }),
      switchMap((processComment) => {
        if (!processComment) {
          return throwError(
            () =>
              'No se encontro el elemento con el id ' + id_processComment + '!'
          );
        }
        return of(processComment);
      })
    );
  }
  /**
   * update
   * @param processComment
   */
  update(processComment: ProcessComment): Observable<any> {
    return this.processComments$.pipe(
      take(1),
      switchMap((processComments) =>
        this._httpClient
          .patch(this._url + '/update', processComment, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _processComment: ProcessComment = response.body;
              /**
               * Find the index of the updated processComment
               */
              const index = processComments.findIndex(
                (item) =>
                  item.id_process_comment == processComment.id_process_comment
              );
              /**
               * Update the processComment
               */
              processComments[index] = _processComment;
              /**
               * Update the processComments
               */
              this._processComments.next(processComments);

              /**
               * Update the processComment
               */
              this._processComment.next(_processComment);

              return of(_processComment);
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_process_comment
   */
  delete(id_user_: string, id_process_comment: string): Observable<any> {
    return this.processComments$.pipe(
      take(1),
      switchMap((processComments) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_process_comment },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated processComment
                 */
                const index = processComments.findIndex(
                  (item) => item.id_process_comment == id_process_comment
                );
                /**
                 * Delete the object of array
                 */
                processComments.splice(index, 1);
                /**
                 * Update the processComments
                 */
                this._processComments.next(processComments);
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
