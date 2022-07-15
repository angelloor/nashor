// import { angelAnimations } from '@angel/animations';
// import { AngelAlertType } from '@angel/components/alert';
// import {
//   ActionAngelConfirmation,
//   AngelConfirmationService,
// } from '@angel/services/confirmation';
// import { OverlayRef } from '@angular/cdk/overlay';
// import { DOCUMENT } from '@angular/common';
// import { ChangeDetectorRef, Component, Inject, OnInit } from '@angular/core';
// import { FormBuilder, FormGroup, Validators } from '@angular/forms';
// import { ActivatedRoute, Router } from '@angular/router';
// import { Store } from '@ngrx/store';
// import { AppInitialData, MessageAPI } from 'app/core/app/app.type';
// import { LayoutService } from 'app/layout/layout.service';
// import { NotificationService } from 'app/shared/notification/notification.service';
// import { filter, fromEvent, merge, Subject, takeUntil } from 'rxjs';
// import { level } from '../../level/level.data';
// import { LevelService } from '../../level/level.service';
// import { Level } from '../../level/level.types';
// import { official } from '../../official/official.data';
// import { OfficialService } from '../../official/official.service';
// import { Official } from '../../official/official.types';
// import { process } from '../../process/process.data';
// import { ProcessService } from '../../process/process.service';
// import { Process } from '../../process/process.types';
// import { TaskListComponent } from '../list/list.component';
// import { TaskService } from '../task.service';
// import {
//   Task,
//   TYPE_ACTION,
//   TYPE_ACTION_ENUM,
//   _typeAction,
// } from '../task.types';

// @Component({
//   selector: 'task-details',
//   templateUrl: './details.component.html',
//   animations: angelAnimations,
// })
// export class TaskDetailsComponent implements OnInit {
//   listProcess: Process[] = [];
//   selectedProcess: Process = process;

//   listOfficial: Official[] = [];
//   selectedOfficial: Official = official;

//   listLevel: Level[] = [];
//   selectedLevel: Level = level;

//   nameEntity: string = 'Tarea';
//   private data!: AppInitialData;

//   /**
//    * Type Enum TYPE_ACTION
//    */
//   typeAction: TYPE_ACTION_ENUM[] = _typeAction;

//   typeActionSelect!: TYPE_ACTION_ENUM;

//   /**
//    * Type Enum TYPE_ACTION
//    */

//   editMode: boolean = false;
//   /**
//    * Alert
//    */
//   alert: { type: AngelAlertType; message: string } = {
//     type: 'error',
//     message: '',
//   };
//   showAlert: boolean = false;
//   /**
//    * Alert
//    */
//   task!: Task;
//   taskForm!: FormGroup;
//   private tasks!: Task[];

//   private _tagsPanelOverlayRef!: OverlayRef;
//   private _unsubscribeAll: Subject<any> = new Subject<any>();
//   /**
//    * isOpenModal
//    */
//   isOpenModal: boolean = false;
//   /**
//    * isOpenModal
//    */
//   /**
//    * Constructor
//    */
//   constructor(
//     private _store: Store<{ global: AppInitialData }>,
//     private _changeDetectorRef: ChangeDetectorRef,
//     private _taskListComponent: TaskListComponent,
//     private _taskService: TaskService,
//     @Inject(DOCUMENT) private _document: any,
//     private _formBuilder: FormBuilder,
//     private _activatedRoute: ActivatedRoute,
//     private _router: Router,
//     private _notificationService: NotificationService,
//     private _angelConfirmationService: AngelConfirmationService,
//     private _layoutService: LayoutService,
//     private _processService: ProcessService,
//     private _officialService: OfficialService,
//     private _levelService: LevelService
//   ) {}

//   /** ----------------------------------------------------------------------------------------------------- */
//   /** @ Lifecycle hooks
// 	  /** ----------------------------------------------------------------------------------------------------- */

//   /**
//    * On init
//    */
//   ngOnInit(): void {
//     /**
//      * isOpenModal
//      */
//     this._layoutService.isOpenModal$
//       .pipe(takeUntil(this._unsubscribeAll))
//       .subscribe((_isOpenModal: boolean) => {
//         this.isOpenModal = _isOpenModal;
//       });
//     /**
//      * isOpenModal
//      */
//     /**
//      * Subscribe to user changes of state
//      */
//     this._store.pipe(takeUntil(this._unsubscribeAll)).subscribe((state) => {
//       this.data = state.global;
//     });
//     /**
//      * Create the task form
//      */
//     this.taskForm = this._formBuilder.group({
//       id_task: [''],
//       id_process: ['', [Validators.required]],
//       id_official: ['', [Validators.required]],
//       id_level: ['', [Validators.required]],
//       creation_date_task: ['', [Validators.required]],
//       type_action: ['', [Validators.required]],
//       action_date_task: ['', [Validators.required]],
//       finished_task: ['', [Validators.required]],
//     });
//     /**
//      * Get the tasks
//      */
//     this._taskService.tasks$
//       .pipe(takeUntil(this._unsubscribeAll))
//       .subscribe((tasks: Task[]) => {
//         this.tasks = tasks;
//         /**
//          * Mark for check
//          */
//         this._changeDetectorRef.markForCheck();
//       });
//     /**
//      * Get the task
//      */
//     this._taskService.task$
//       .pipe(takeUntil(this._unsubscribeAll))
//       .subscribe((task: Task) => {
//         /**
//          * Get the task
//          */
//         this.task = task;

//         /**
//          * Type Enum TYPE_ACTION
//          */
//         this.typeActionSelect = this.typeAction.find(
//           (e_action) => e_action.value_type == this.task.type_action
//         )!;
//         /**
//          * Type Enum TYPE_ACTION
//          */

//         // Process
//         this._processService
//           .queryRead('*')
//           .pipe(takeUntil(this._unsubscribeAll))
//           .subscribe((processs: Process[]) => {
//             this.listProcess = processs;

//             this.selectedProcess = this.listProcess.find(
//               (item) =>
//                 item.id_process == this.task.process.id_process.toString()
//             )!;
//           });

//         // Official
//         this._officialService
//           .queryRead('*')
//           .pipe(takeUntil(this._unsubscribeAll))
//           .subscribe((officials: Official[]) => {
//             this.listOfficial = officials;

//             this.selectedOfficial = this.listOfficial.find(
//               (item) =>
//                 item.id_official == this.task.official.id_official.toString()
//             )!;
//           });

//         // Level
//         this._levelService
//           .queryRead('*')
//           .pipe(takeUntil(this._unsubscribeAll))
//           .subscribe((levels: Level[]) => {
//             this.listLevel = levels;

//             this.selectedLevel = this.listLevel.find(
//               (item) => item.id_level == this.task.level.id_level.toString()
//             )!;
//           });

//         /**
//          * Patch values to the form
//          */
//         this.patchForm();

//         /**
//          * Mark for check
//          */
//         this._changeDetectorRef.markForCheck();
//       });
//     /**
//      * Shortcuts
//      */
//     merge(
//       fromEvent(this._document, 'keydown').pipe(
//         takeUntil(this._unsubscribeAll),
//         filter<KeyboardEvent | any>((e) => e.key === 'Escape')
//       )
//     )
//       .pipe(takeUntil(this._unsubscribeAll))
//       .subscribe((keyUpOrKeyDown) => {
//         /**
//          * Shortcut Escape
//          */
//         if (!this.isOpenModal && keyUpOrKeyDown.key == 'Escape') {
//           /**
//            * Navigate parentUrl
//            */
//           const parentUrl = this._router.url.split('/').slice(0, -1).join('/');
//           this._router.navigate([parentUrl]);
//         }
//       });
//     /**
//      * Shortcuts
//      */
//   }
//   /**
//    * Pacth the form with the information of the database
//    */
//   patchForm(): void {
//     this.taskForm.patchValue({
//       ...this.task,
//       id_process: this.task.process.id_process,
//       id_official: this.task.official.id_official,
//       id_level: this.task.level.id_level,
//     });
//   }
//   /**
//    * On destroy
//    */
//   ngOnDestroy(): void {
//     /**
//      * Unsubscribe from all subscriptions
//      */
//     this._unsubscribeAll.next(0);
//     this._unsubscribeAll.complete();
//     /**
//      * Dispose the overlays if they are still on the DOM
//      */
//     if (this._tagsPanelOverlayRef) {
//       this._tagsPanelOverlayRef.dispose();
//     }
//   }

//   /** ----------------------------------------------------------------------------------------------------- */
//   /** @ Public methods
// 	  /** ----------------------------------------------------------------------------------------------------- */
//   /**
//    * Update the task
//    */
//   updateTask(): void {
//     /**
//      * Get the task
//      */
//     const id_user_ = this.data.user.id_user;
//     let task = this.taskForm.getRawValue();
//     /**
//      * Delete whitespace (trim() the atributes type string)
//      */
//     task = {
//       ...task,
//       id_user_: parseInt(id_user_),
//       id_task: parseInt(task.id_task),
//       process: {
//         id_process: parseInt(task.id_process),
//       },
//       official: {
//         id_official: parseInt(task.id_official),
//       },
//       level: {
//         id_level: parseInt(task.id_level),
//       },
//     };
//     /**
//      * Update
//      */
//     this._taskService
//       .update(task)
//       .pipe(takeUntil(this._unsubscribeAll))
//       .subscribe({
//         next: (_task: Task) => {
//           if (_task) {
//             this._notificationService.success(
//               'Tarea actualizada correctamente'
//             );
//           } else {
//             this._notificationService.error(
//               '¡Error interno!, consulte al administrador.'
//             );
//           }
//         },
//         error: (error: { error: MessageAPI }) => {
//           this._notificationService.error(
//             !error.error
//               ? '¡Error interno!, consulte al administrador.'
//               : !error.error.description
//               ? '¡Error interno!, consulte al administrador.'
//               : error.error.description
//           );
//         },
//       });
//   }
//   /**
//    * Delete the task
//    */
//   deleteTask(): void {
//     this._angelConfirmationService
//       .open({
//         title: 'Eliminar tarea',
//         message:
//           '¿Estás seguro de que deseas eliminar esta tarea? ¡Esta acción no se puede deshacer!',
//       })
//       .afterClosed()
//       .pipe(takeUntil(this._unsubscribeAll))
//       .subscribe((confirm: ActionAngelConfirmation) => {
//         if (confirm === 'confirmed') {
//           /**
//            * Get the current task's id
//            */
//           const id_user_ = this.data.user.id_user;
//           const id_task = this.task.id_task;
//           /**
//            * Get the next/previous task's id
//            */
//           const currentIndex = this.tasks.findIndex(
//             (item) => item.id_task === id_task
//           );

//           const nextIndex =
//             currentIndex + (currentIndex === this.tasks.length - 1 ? -1 : 1);
//           const nextId =
//             this.tasks.length === 1 && this.tasks[0].id_task === id_task
//               ? null
//               : this.tasks[nextIndex].id_task;
//           /**
//            * Delete
//            */
//           this._taskService
//             .delete(id_user_, id_task)
//             .pipe(takeUntil(this._unsubscribeAll))
//             .subscribe({
//               next: (response: boolean) => {
//                 if (response) {
//                   /**
//                    * Return if the task wasn't deleted...
//                    */
//                   this._notificationService.success(
//                     'Tarea eliminada correctamente'
//                   );
//                   /**
//                    * Get the current activated route
//                    */
//                   let route = this._activatedRoute;
//                   while (route.firstChild) {
//                     route = route.firstChild;
//                   }
//                   /**
//                    * Navigate to the next task if available
//                    */
//                   if (nextId) {
//                     this._router.navigate(['../', nextId], {
//                       relativeTo: route,
//                     });
//                   } else {
//                     /**
//                      * Otherwise, navigate to the parent
//                      */
//                     this._router.navigate(['../'], { relativeTo: route });
//                   }
//                 } else {
//                   this._notificationService.error(
//                     '¡Error interno!, consulte al administrador.'
//                   );
//                 }
//               },
//               error: (error: { error: MessageAPI }) => {
//                 this._notificationService.error(
//                   !error.error
//                     ? '¡Error interno!, consulte al administrador.'
//                     : !error.error.description
//                     ? '¡Error interno!, consulte al administrador.'
//                     : error.error.description
//                 );
//               },
//             });
//           /**
//            * Mark for check
//            */
//           this._changeDetectorRef.markForCheck();
//         }
//         this._layoutService.setOpenModal(false);
//       });
//   }
//   /**
//    * getTypeTaskEnum
//    */
//   getTypeTaskEnum(type_action: TYPE_ACTION): TYPE_ACTION_ENUM {
//     return this.typeAction.find(
//       (e_action) => e_action.value_type == type_action
//     )!;
//   }
// }
