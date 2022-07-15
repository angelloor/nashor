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
import { task, tasks } from './task.data';
import { Task } from './task.types';

@Injectable({
  providedIn: 'root',
})
export class TaskService {
  private _url: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _task: BehaviorSubject<Task> = new BehaviorSubject(task);
  private _tasks: BehaviorSubject<Task[]> = new BehaviorSubject(tasks);

  constructor(private _httpClient: HttpClient) {
    this._url = environment.urlBackend + '/app/business/task';
  }
  /**
   * Getter
   */
  get task$(): Observable<Task> {
    return this._task.asObservable();
  }
  /**
   * Getter for _tasks
   */
  get tasks$(): Observable<Task[]> {
    return this._tasks.asObservable();
  }
  /**
   * create
   */
  create(id_user_: string): Observable<any> {
    return this._tasks.pipe(
      take(1),
      switchMap((tasks) =>
        this._httpClient
          .post(
            this._url + '/create',
            {
              id_user_: parseInt(id_user_),
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
              const _task: Task = response.body;
              /**
               * Update the task in the store
               */
              this._tasks.next([_task, ...tasks]);

              return of(_task);
            })
          )
      )
    );
  }
  /**
   * queryRead
   * @param query
   */
  queryRead(query: string): Observable<Task[]> {
    return this._httpClient
      .get<Task[]>(this._url + `/queryRead/${query ? query : '*'}`)
      .pipe(
        tap((tasks: Task[]) => {
          if (tasks) {
            this._tasks.next(tasks);
          } else {
            this._tasks.next([]);
          }
        })
      );
  }
  /**
   * byProcessQueryRead
   * @param id_process
   * @param query
   */
  byProcessQueryRead(id_process: string, query: string): Observable<Task[]> {
    return this._httpClient
      .get<Task[]>(
        this._url + `/byProcessQueryRead/${id_process}/${query ? query : '*'}`
      )
      .pipe(
        tap((tasks: Task[]) => {
          if (tasks) {
            this._tasks.next(tasks);
          } else {
            this._tasks.next([]);
          }
        })
      );
  }
  /**
   * byOfficialQueryRead
   * @param id_official
   * @param query
   */
  byOfficialQueryRead(id_official: string, query: string): Observable<Task[]> {
    return this._httpClient
      .get<Task[]>(
        this._url + `/byOfficialQueryRead/${id_official}/${query ? query : '*'}`
      )
      .pipe(
        tap((tasks: Task[]) => {
          if (tasks) {
            this._tasks.next(tasks);
          } else {
            this._tasks.next([]);
          }
        })
      );
  }
  /**
   * byLevelQueryRead
   * @param id_level
   * @param query
   */
  byLevelQueryRead(id_level: string, query: string): Observable<Task[]> {
    return this._httpClient
      .get<Task[]>(
        this._url + `/byLevelQueryRead/${id_level}/${query ? query : '*'}`
      )
      .pipe(
        tap((tasks: Task[]) => {
          if (tasks) {
            this._tasks.next(tasks);
          } else {
            this._tasks.next([]);
          }
        })
      );
  }
  /**
   * specificRead
   * @param id_task
   */
  specificRead(id_task: string): Observable<Task> {
    return this._httpClient
      .get<Task>(this._url + `/specificRead/${id_task}`)
      .pipe(
        tap((task: Task) => {
          this._task.next(task);
          return tasks;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(id_task: string): Observable<Task> {
    return this._tasks.pipe(
      take(1),
      map((tasks) => {
        /**
         * Find
         */
        const task = tasks.find((item) => item.id_task == id_task) || null;
        /**
         * Update
         */
        this._task.next(task!);
        /**
         * Return
         */
        return task;
      }),
      switchMap((task) => {
        if (!task) {
          return throwError(
            () => 'No se encontro el elemento con el id ' + id_task + '!'
          );
        }
        return of(task);
      })
    );
  }
  /**
   * update
   * @param task
   */
  update(task: Task): Observable<any> {
    return this.tasks$.pipe(
      take(1),
      switchMap((tasks) =>
        this._httpClient
          .patch(this._url + '/update', task, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _task: Task = response.body;
              /**
               * Find the index of the updated task
               */
              const index = tasks.findIndex(
                (item) => item.id_task == task.id_task
              );
              /**
               * Update the task
               */
              tasks[index] = _task;
              /**
               * Update the tasks
               */
              this._tasks.next(tasks);

              /**
               * Update the task
               */
              this._task.next(_task);

              return of(_task);
            })
          )
      )
    );
  }
  /**
   * reasign
   * @param task
   */
  reasign(task: Task): Observable<any> {
    return this.tasks$.pipe(
      take(1),
      switchMap((tasks) =>
        this._httpClient
          .patch(this._url + '/reasign', task, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _task: Task = response.body;
              /**
               * Find the index of the updated task
               */
              const index = tasks.findIndex(
                (item) => item.id_task == task.id_task
              );
              /**
               * Update the task
               */
              tasks[index] = _task;
              /**
               * Update the tasks
               */
              this._tasks.next(tasks);

              /**
               * Update the task
               */
              this._task.next(_task);

              return of(_task);
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_task
   */
  delete(id_user_: string, id_task: string): Observable<any> {
    return this.tasks$.pipe(
      take(1),
      switchMap((tasks) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_task },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated task
                 */
                const index = tasks.findIndex(
                  (item) => item.id_task == id_task
                );
                /**
                 * Delete the object of array
                 */
                tasks.splice(index, 1);
                /**
                 * Update the tasks
                 */
                this._tasks.next(tasks);
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
