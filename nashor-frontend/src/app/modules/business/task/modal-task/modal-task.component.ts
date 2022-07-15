import { AngelAlertType } from '@angel/components/alert';
import {
  ActionAngelConfirmation,
  AngelConfirmationService,
} from '@angel/services/confirmation';
import { OverlayRef } from '@angular/cdk/overlay';
import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { Store } from '@ngrx/store';
import { AppInitialData, MessageAPI } from 'app/core/app/app.type';
import { LayoutService } from 'app/layout/layout.service';
import { NotificationService } from 'app/shared/notification/notification.service';
import { LocalDatePipe } from 'app/shared/pipes/local-date.pipe';
import { GlobalUtils } from 'app/utils/GlobalUtils';
import { FullDate } from 'app/utils/utils.types';
import { Subject, takeUntil } from 'rxjs';
import { levelProfile } from '../../level-profile/level-profile.data';
import { LevelProfileService } from '../../level-profile/level-profile.service';
import { LevelProfile } from '../../level-profile/level-profile.types';
import { levelStatus } from '../../level-status/level-status.data';
import { LevelStatusService } from '../../level-status/level-status.service';
import { LevelStatus } from '../../level-status/level-status.types';
import { level } from '../../level/level.data';
import { LevelService } from '../../level/level.service';
import { Level } from '../../level/level.types';
import { ModalSelectOfficialByLevelProfileService } from '../../official/modal-select-official-by-level-profile/modal-select-official-by-level-profile.service';
import { official } from '../../official/official.data';
import { OfficialService } from '../../official/official.service';
import { Official } from '../../official/official.types';
import { processType } from '../../process-type/process-type.data';
import { ProcessTypeService } from '../../process-type/process-type.service';
import { ProcessType } from '../../process-type/process-type.types';
import { process } from '../../process/process.data';
import { ProcessService } from '../../process/process.service';
import { Process } from '../../process/process.types';
import { ModalTaskRealizeService } from '../modal-task-realize/modal-task-realize.service';
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
import { ModalTaskService } from './modal-task.service';

@Component({
  selector: 'app-modal-task',
  templateUrl: './modal-task.component.html',
  styleUrls: ['modal-task.component.scss'],
  providers: [LocalDatePipe],
})
export class ModalTaskComponent implements OnInit {
  listProcess: Process[] = [];
  selectedProcess: Process = process;

  listOfficial: Official[] = [];
  selectedOfficial: Official = official;

  listLevel: Level[] = [];
  selectedLevel: Level = level;

  listProcessType: ProcessType[] = [];
  selectedProcessType: ProcessType = processType;

  listLevelProfile: LevelProfile[] = [];
  selectedLevelProfile: LevelProfile = levelProfile;

  listLevelStatus: LevelStatus[] = [];
  selectedLevelStatus: LevelStatus = levelStatus;

  id_company: string = '';

  nameEntity: string = 'Tarea';
  private data!: AppInitialData;

  /**
   * Type Enum TYPE_STATUS_TASK
   */
  typeStatusTask: TYPE_STATUS_TASK_ENUM[] = _typeStatusTask;

  typeStatusTaskSelect!: TYPE_STATUS_TASK_ENUM;

  /**
   * Type Enum TYPE_STATUS_TASK
   */

  /**
   * Type Enum TYPE_ACTION_TASK
   */
  typeActionTask: TYPE_ACTION_TASK_ENUM[] = _typeActionTask;

  typeActionTaskSelect!: TYPE_ACTION_TASK_ENUM;

  /**
   * Type Enum TYPE_ACTION_TASK
   */

  editMode: boolean = false;
  /**
   * Alert
   */
  alert: { type: AngelAlertType; message: string } = {
    type: 'error',
    message: '',
  };
  showAlert: boolean = false;
  /**
   * Alert
   */
  task!: Task;
  taskForm!: FormGroup;
  private tasks!: Task[];

  private _tagsPanelOverlayRef!: OverlayRef;
  private _unsubscribeAll: Subject<any> = new Subject<any>();
  /**
   * isOpenModal
   */
  isOpenModal: boolean = false;
  /**
   * isOpenModal
   */
  /**
   * Constructor
   */
  constructor(
    private _store: Store<{ global: AppInitialData }>,
    private _changeDetectorRef: ChangeDetectorRef,
    private _taskService: TaskService,
    private _formBuilder: FormBuilder,
    private _activatedRoute: ActivatedRoute,
    private _router: Router,
    private _notificationService: NotificationService,
    private _angelConfirmationService: AngelConfirmationService,
    private _layoutService: LayoutService,
    private _localDatePipe: LocalDatePipe,
    private _processService: ProcessService,
    private _officialService: OfficialService,
    private _levelService: LevelService,
    private _modalTaskService: ModalTaskService,
    private _processTypeService: ProcessTypeService,
    private _levelProfileService: LevelProfileService,
    private _levelStatusService: LevelStatusService,
    private _modalSelectOfficialByLevelProfileService: ModalSelectOfficialByLevelProfileService,
    private _globalUtils: GlobalUtils,
    private _modalTaskRealizeService: ModalTaskRealizeService
  ) {}

  /** ----------------------------------------------------------------------------------------------------- */
  /** @ Lifecycle hooks
	  /** ----------------------------------------------------------------------------------------------------- */

  /**
   * On init
   */
  ngOnInit(): void {
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
      this.id_company = this.data.user.company.id_company;
    });
    /**
     * Create the task form
     */
    this.taskForm = this._formBuilder.group({
      id_task: [''],
      id_process: ['', [Validators.required]],
      id_official: ['', [Validators.required]],
      id_level: ['', [Validators.required]],
      creation_date_task: ['', [Validators.required]],
      type_status_task: ['', [Validators.required]],
      type_action_task: ['', [Validators.required]],
      action_date_task: ['', [Validators.required]],
    });
    /**
     * Get the tasks
     */
    this._taskService.tasks$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((tasks: Task[]) => {
        this.tasks = tasks;
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
    /**
     * Get the task
     */
    this._taskService.task$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((task: Task) => {
        /**
         * Get the task
         */
        this.task = task;

        console.log(this.task);

        /**
         * Type Enum TYPE_STATUS_TAKS
         */
        this.typeStatusTaskSelect = this.typeStatusTask.find(
          (type_status) => type_status.value_type == this.task.type_status_task
        )!;
        /**
         * Type Enum TYPE_STATUS_TAKS
         */

        /**
         * Type Enum TYPE_ACTION_TAKS
         */
        this.typeActionTaskSelect = this.typeActionTask.find(
          (type_action) => type_action.value_type == this.task.type_action_task
        )!;
        /**
         * Type Enum TYPE_ACTION_TAKS
         */

        // Process
        this._processService
          .queryRead('*')
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((processs: Process[]) => {
            this.listProcess = processs;

            this.selectedProcess = this.listProcess.find(
              (item) =>
                item.id_process == this.task.process.id_process.toString()
            )!;
          });

        // Official
        this._officialService
          .queryRead('*')
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((officials: Official[]) => {
            this.listOfficial = officials;

            this.selectedOfficial = this.listOfficial.find(
              (item) =>
                item.id_official == this.task.official.id_official.toString()
            )!;
          });

        // Level
        this._levelService
          .queryRead('*')
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((levels: Level[]) => {
            this.listLevel = levels;

            this.selectedLevel = this.listLevel.find(
              (item) => item.id_level == this.task.level.id_level.toString()
            )!;
          });

        // ProcessType
        this._processTypeService
          .byCompanyQueryRead(this.id_company, '*')
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((process_types: ProcessType[]) => {
            this.listProcessType = process_types;

            this.selectedProcessType = this.listProcessType.find(
              (item) =>
                item.id_process_type ==
                this.task.process.process_type.id_process_type.toString()
            )!;
          });

        // LevelProfile
        this._levelProfileService
          .byCompanyQueryRead(this.id_company, '*')
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((level_profiles: LevelProfile[]) => {
            this.listLevelProfile = level_profiles;

            this.selectedLevelProfile = this.listLevelProfile.find(
              (item) =>
                item.id_level_profile ==
                this.task.level.level_profile.id_level_profile.toString()
            )!;
          });

        // LevelStatus
        this._levelStatusService
          .byCompanyQueryRead(this.id_company, '*')
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((level_statuss: LevelStatus[]) => {
            this.listLevelStatus = level_statuss;

            this.selectedLevelStatus = this.listLevelStatus.find(
              (item) =>
                item.id_level_status ==
                this.task.level.level_status.id_level_status.toString()
            )!;
          });

        /**
         * Patch values to the form
         */
        this.patchForm();

        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
  }

  /**
   * Pacth the form with the information of the database
   */
  patchForm(): void {
    this.taskForm.patchValue({
      ...this.task,
      id_process: this.task.process.id_process,
      id_official: this.task.official.id_official,
      id_level: this.task.level.id_level,
    });
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
    /**
     * Dispose the overlays if they are still on the DOM
     */
    if (this._tagsPanelOverlayRef) {
      this._tagsPanelOverlayRef.dispose();
    }
  }

  /** ----------------------------------------------------------------------------------------------------- */
  /** @ Public methods
      /** ----------------------------------------------------------------------------------------------------- */
  /**
   * Update the task
   */
  updateTask(): void {
    /**
     * Get the task
     */
    const id_user_ = this.data.user.id_user;
    let task = this.taskForm.getRawValue();
    /**
     * Delete whitespace (trim() the atributes type string)
     */
    task = {
      ...task,
      id_user_: parseInt(id_user_),
      id_task: parseInt(task.id_task),
      process: {
        id_process: parseInt(task.id_process),
      },
      official: {
        id_official: parseInt(task.id_official),
      },
      level: {
        id_level: parseInt(task.id_level),
      },
    };
    /**
     * Update
     */
    this._taskService
      .update(task)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_task: Task) => {
          if (_task) {
            this._notificationService.success(
              'Tarea actualizada correctamente'
            );
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
  /**
   * Delete the task
   */
  deleteTask(): void {
    this._angelConfirmationService
      .open({
        title: 'Eliminar tarea',
        message:
          '¿Estás seguro de que deseas eliminar esta tarea? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          /**
           * Get the current task's id
           */
          const id_user_ = this.data.user.id_user;
          const id_task = this.task.id_task;
          /**
           * Get the next/previous task's id
           */
          const currentIndex = this.tasks.findIndex(
            (item) => item.id_task === id_task
          );

          const nextIndex =
            currentIndex + (currentIndex === this.tasks.length - 1 ? -1 : 1);
          const nextId =
            this.tasks.length === 1 && this.tasks[0].id_task === id_task
              ? null
              : this.tasks[nextIndex].id_task;
          /**
           * Delete
           */
          this._taskService
            .delete(id_user_, id_task)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (response: boolean) => {
                if (response) {
                  /**
                   * Return if the task wasn't deleted...
                   */
                  this._notificationService.success(
                    'Tarea eliminada correctamente'
                  );
                  /**
                   * Get the current activated route
                   */
                  let route = this._activatedRoute;
                  while (route.firstChild) {
                    route = route.firstChild;
                  }
                  /**
                   * Navigate to the next task if available
                   */
                  if (nextId) {
                    this._router.navigate(['../', nextId], {
                      relativeTo: route,
                    });
                  } else {
                    /**
                     * Otherwise, navigate to the parent
                     */
                    this._router.navigate(['../'], { relativeTo: route });
                  }
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
          /**
           * Mark for check
           */
          this._changeDetectorRef.markForCheck();
        }
        this._layoutService.setOpenModal(false);
      });
  }
  /**
   * reasign
   */
  reasign() {
    const id_level_profile: string =
      this.task.level.level_profile.id_level_profile;
    const id_user_ = this.data.user.id_user;

    this._modalSelectOfficialByLevelProfileService
      .openModalSelectOfficialByLevelProfile(id_level_profile, id_user_)
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((id_official: string) => {
        if (id_official) {
          /**
           * Get the task
           */
          const id_user_ = this.data.user.id_user;
          let task = this.taskForm.getRawValue();
          /**
           * Delete whitespace (trim() the atributes type string)
           */
          task = {
            ...task,
            id_user_: parseInt(id_user_),
            id_task: parseInt(task.id_task),
            process: {
              id_process: parseInt(task.id_process),
            },
            official: {
              id_official: parseInt(id_official),
            },
            level: {
              id_level: parseInt(task.id_level),
            },
          };
          /**
           * Update
           */
          this._taskService
            .reasign(task)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (_task: Task) => {
                if (_task) {
                  this._notificationService.success(
                    'Tarea reasignada correctamente'
                  );
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
      });
  }
  /**
   * openModalTaskRealize
   */
  openModalTaskRealize(): void {
    this._modalTaskRealizeService.openModalTaskRealize(
      this.task.level.template.id_template
    );
  }
  /**
   * @param time
   */
  parseTime(time: string) {
    const dateTimeNow: FullDate = this._globalUtils.getFullDate(time);
    const dateS: string = `${dateTimeNow.fullYear}-${dateTimeNow.month}-${dateTimeNow.day}T${dateTimeNow.hours}:${dateTimeNow.minutes}:${dateTimeNow.seconds}`;
    return this._localDatePipe.transform(dateS, 'medium');
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
   * closeModalTask
   */
  closeModalTask(): void {
    this._modalTaskService.closeModalTask();
  }
}
