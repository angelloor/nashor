import {
  ActionAngelConfirmation,
  AngelConfirmationService,
} from '@angel/services/confirmation';
import { AngelMediaWatcherService } from '@angel/services/media-watcher';
import { DOCUMENT } from '@angular/common';
import {
  ChangeDetectorRef,
  Component,
  Inject,
  OnInit,
  ViewChild,
} from '@angular/core';
import { FormControl } from '@angular/forms';
import { MatDrawer } from '@angular/material/sidenav';
import { ActivatedRoute, Router } from '@angular/router';
import { Store } from '@ngrx/store';
import { AppInitialData, MessageAPI } from 'app/core/app/app.type';
import { AuthService } from 'app/core/auth/auth.service';
import { LayoutService } from 'app/layout/layout.service';
import { NotificationService } from 'app/shared/notification/notification.service';
import { LocalDatePipe } from 'app/shared/pipes/local-date.pipe';
import { GlobalUtils } from 'app/utils/GlobalUtils';
import { FullDate } from 'app/utils/utils.types';
import { fromEvent, merge, Observable, Subject, timer } from 'rxjs';
import {
  filter,
  finalize,
  switchMap,
  takeUntil,
  takeWhile,
  tap,
} from 'rxjs/operators';
import { official } from '../../official/official.data';
import { Official } from '../../official/official.types';
import { TaskService } from '../task.service';
import {
  Task,
  TYPE_ACTION_TASK,
  TYPE_ACTION_TASK_ENUM,
  TYPE_STATUS_TASK,
  TYPE_STATUS_TASK_ENUM,
  _typeActionTask,
  _typeStatusTask,
} from '../task.types';

@Component({
  selector: 'task-list',
  templateUrl: './list.component.html',
  providers: [LocalDatePipe],
})
export class TaskListComponent implements OnInit {
  @ViewChild('matDrawer', { static: true }) matDrawer!: MatDrawer;
  count: number = 0;
  tasks$!: Observable<Task[]>;

  openMatDrawer: boolean = false;

  private data!: AppInitialData;
  /**
   * Shortcut
   */
  private keyControl: boolean = false;
  private keyShift: boolean = false;
  private keyAlt: boolean = false;
  private timeToWaitKey: number = 500; //ms
  /**
   * Shortcut
   */

  /**
   * Type Enum TYPE_STATUS_TASK
   */
  typeStatusTask: TYPE_STATUS_TASK_ENUM[] = _typeStatusTask;
  /**
   * Type Enum TYPE_STATUS_TASK
   */

  /**
   * Type Enum TYPE_ACTION_TASK
   */
  typeActionTask: TYPE_ACTION_TASK_ENUM[] = _typeActionTask;
  /**
   * Type Enum TYPE_ACTION_TASK
   */

  drawerMode!: 'side' | 'over';
  searchInputControl: FormControl = new FormControl();
  selectedTask!: Task;

  private _unsubscribeAll: Subject<any> = new Subject<any>();
  /**
   * isOpenModal
   */
  isOpenModal: boolean = false;

  official: Official = official;
  /**
   * isOpenModal
   */
  constructor(
    private _store: Store<{ global: AppInitialData }>,
    private _activatedRoute: ActivatedRoute,
    private _changeDetectorRef: ChangeDetectorRef,
    @Inject(DOCUMENT) private _document: any,
    private _router: Router,
    private _angelMediaWatcherService: AngelMediaWatcherService,
    private _taskService: TaskService,
    private _notificationService: NotificationService,
    private _angelConfirmationService: AngelConfirmationService,
    private _layoutService: LayoutService,
    private _authService: AuthService,
    private _localDatePipe: LocalDatePipe,
    private _globalUtils: GlobalUtils
  ) {}

  ngOnInit(): void {
    /**
     * checkSession
     */
    this._authService
      .checkSession()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe();
    /**
     * checkSession
     */
    /**
     * isOpenModal
     */
    this._layoutService.isOpenModal$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_isOpenModal: boolean) => {
        this.isOpenModal = _isOpenModal;
      });
    /**
     * isOpenModal
     */
    /**
     * Subscribe to user changes of state
     */
    this._store.pipe(takeUntil(this._unsubscribeAll)).subscribe((state) => {
      this.data = state.global;
      if (this.data.official) {
        this.official = this.data.official;
      }
    });

    /**
     * Get the tasks
     */
    this.tasks$ = this._taskService.tasks$;
    /**
     *  queryRead * byOfficialQueryRead
     */
    if (this.official) {
      this._taskService
        .byOfficialQueryRead(this.official.id_official, '*')
        .pipe(takeUntil(this._unsubscribeAll))
        .subscribe((tasks: Task[]) => {
          /**
           * Update the counts
           */
          this.count = tasks.length;
          /**
           * Mark for check
           */
          this._changeDetectorRef.markForCheck();
        });
    }
    /**
     *  Count Subscribe
     */
    this._taskService.tasks$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((tasks: Task[]) => {
        console.log(tasks);
        /**
         * Update the counts
         */
        this.count = tasks.length;
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
    /**
     * Subscribe to search input field value changes
     */
    this.searchInputControl.valueChanges
      .pipe(
        takeUntil(this._unsubscribeAll),
        switchMap((query) => {
          /**
           * Search
           */
          return this._taskService.byOfficialQueryRead(
            this.official.id_official,
            query.toLowerCase()
          );
        })
      )
      .subscribe();
    /**
     * Subscribe to media changes
     */
    this._angelMediaWatcherService.onMediaChange$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe(({ matchingAliases }) => {
        /**
         * Set the drawerMode if the given breakpoint is active
         */
        if (matchingAliases.includes('lg')) {
          this.drawerMode = 'side';
        } else {
          this.drawerMode = 'over';
        }
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
    /**
     * Subscribe to MatDrawer opened change
     */
    this.matDrawer.openedChange
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((opened) => {
        this.openMatDrawer = opened;
        if (!opened) {
          /**
           * Remove the selected when drawer closed
           */
          this.selectedTask = null!;
          /**
           * Mark for check
           */
          this._changeDetectorRef.markForCheck();
        }
      });
    /**
     * Shortcuts
     */
    merge(
      fromEvent(this._document, 'keydown').pipe(
        takeUntil(this._unsubscribeAll),
        filter<KeyboardEvent | any>((e) => e.key === 'Control')
      ),
      fromEvent(this._document, 'keydown').pipe(
        takeUntil(this._unsubscribeAll),
        filter<KeyboardEvent | any>((e) => e.key === 'Shift')
      ),
      fromEvent(this._document, 'keydown').pipe(
        takeUntil(this._unsubscribeAll),
        filter<KeyboardEvent | any>((e) => e.key === 'Alt')
      )
    )
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((keyUpOrKeyDown) => {
        /**
         * Shortcut create
         */
        if (keyUpOrKeyDown.key == 'Control') {
          this.keyControl = true;

          timer(100, 100)
            .pipe(
              finalize(() => {
                this.resetKeyboard();
              }),
              takeWhile(() => this.timeToWaitKey > 0),
              takeUntil(this._unsubscribeAll),
              tap(() => this.timeToWaitKey--)
            )
            .subscribe();
        }
        if (keyUpOrKeyDown.key == 'Shift') {
          this.keyShift = true;

          timer(100, 100)
            .pipe(
              finalize(() => {
                this.resetKeyboard();
              }),
              takeWhile(() => this.timeToWaitKey > 0),
              takeUntil(this._unsubscribeAll),
              tap(() => this.timeToWaitKey--)
            )
            .subscribe();
        }
        if (keyUpOrKeyDown.key == 'Alt') {
          this.keyAlt = true;

          timer(100, 100)
            .pipe(
              finalize(() => {
                this.resetKeyboard();
              }),
              takeWhile(() => this.timeToWaitKey > 0),
              takeUntil(this._unsubscribeAll),
              tap(() => this.timeToWaitKey--)
            )
            .subscribe();
        }

        if (
          !this.isOpenModal &&
          this.keyControl &&
          this.keyShift &&
          this.keyAlt
        ) {
          this.createTask();
        }
      });
    /**
     * Shortcuts
     */
  }
  /**
   * resetKeyboard
   */
  private resetKeyboard() {
    this.keyControl = false;
    this.keyShift = false;
    this.keyAlt = false;
  }
  /**
   * On destroy
   */
  ngOnDestroy(): void {
    /**
     * Unsubscribe from all subscriptions
     */
    this._unsubscribeAll.next(0);
    this._unsubscribeAll.complete();
  }

  /** ----------------------------------------------------------------------------------------------------- */
  /** @ Public methods
   /** ----------------------------------------------------------------------------------------------------- */

  /**
   * Go to task
   * @param id_task
   */
  goToEntity(id_task: string): void {
    /**
     * Get the current activated route
     */
    let route = this._activatedRoute;
    while (route.firstChild) {
      route = route.firstChild;
    }
    /**
     * Go to task
     */
    this._router.navigate([this.openMatDrawer ? '../' : './', id_task], {
      relativeTo: route,
    });
    /**
     * Mark for check
     */
    this._changeDetectorRef.markForCheck();
  }
  /**
   * On backdrop clicked
   */
  onBackdropClicked(): void {
    /**
     * Get the current activated route
     */
    let route = this._activatedRoute;
    while (route.firstChild) {
      route = route.firstChild;
    }
    /**
     * Go to the parent route
     */
    this._router.navigate(['../'], { relativeTo: route });
    /**
     * Mark for check
     */
    this._changeDetectorRef.markForCheck();
  }
  /**
   * createTask
   */
  createTask(): void {
    this._angelConfirmationService
      .open({
        title: 'Añadir tarea',
        message:
          '¿Estás seguro de que deseas añadir una nueva tarea? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          const id_user_ = this.data.user.id_user;
          /**
           * Create the task
           */
          this._taskService
            .create(id_user_)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (_task: Task) => {
                if (_task) {
                  this._notificationService.success(
                    'Tarea agregada correctamente'
                  );
                  /**
                   * Go to new task
                   */
                  this.goToEntity(_task.id_task);
                } else {
                  this._notificationService.error(
                    '¡Error interno!, consulte al administrador.'
                  );
                }
              },
              error: (error: { error: MessageAPI }) => {
                this._notificationService.error(
                  !error.error
                    ? '¡Error interno!, consulte al administrador.'
                    : !error.error.description
                    ? '¡Error interno!, consulte al administrador.'
                    : error.error.description
                );
              },
            });
        }
        this._layoutService.setOpenModal(false);
      });
  }
  /**
   * @param time
   */
  parseTime(time: string) {
    let date: string = '';
    if (time != ' ') {
      const dateTimeNow: FullDate = this._globalUtils.getFullDate(time);
      const dateString: string = `${dateTimeNow.fullYear}-${dateTimeNow.month}-${dateTimeNow.day}T${dateTimeNow.hours}:${dateTimeNow.minutes}:${dateTimeNow.seconds}`;
      date = this._localDatePipe.transform(dateString, 'medium');
    }
    return date;
  }
  /**
   * getTypeStatusTaskEnum
   */
  getTypeStatusTaskEnum(
    type_status_task: TYPE_STATUS_TASK
  ): TYPE_STATUS_TASK_ENUM {
    return this.typeStatusTask.find(
      (_type_status_task) => _type_status_task.value_type == type_status_task
    )!;
  }
  /**
   * getTypeActionTaskEnum
   */
  getTypeActionTaskEnum(
    type_action_task: TYPE_ACTION_TASK
  ): TYPE_ACTION_TASK_ENUM {
    return this.typeActionTask.find(
      (_type_action_task) => _type_action_task.value_type == type_action_task
    )!;
  }
  /**
   * Track by function for ngFor loops
   * @param index
   * @param item
   */
  trackByFn(index: number, item: any): any {
    return item.id || index;
  }
}
