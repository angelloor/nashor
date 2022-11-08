import { AngelAlertType } from '@angel/components/alert';
import {
  ActionAngelConfirmation,
  AngelConfirmationService,
} from '@angel/services/confirmation';
import { OverlayRef } from '@angular/cdk/overlay';
import { ChangeDetectorRef, Component, Inject, OnInit } from '@angular/core';
import {
  FormArray,
  FormBuilder,
  FormControl,
  FormGroup,
  Validators,
} from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { ActivatedRoute, Router } from '@angular/router';
import { Store } from '@ngrx/store';
import { AppInitialData, MessageAPI } from 'app/core/app/app.type';
import { LayoutService } from 'app/layout/layout.service';
import { NotificationService } from 'app/shared/notification/notification.service';
import { LocalDatePipe } from 'app/shared/pipes/local-date.pipe';
import { GlobalUtils } from 'app/utils/GlobalUtils';
import { FullDate } from 'app/utils/utils.types';
import { environment } from 'environments/environment';
import { cloneDeep } from 'lodash';
import { Subject, takeUntil } from 'rxjs';
import { ColumnProcessItemService } from '../../column-process-item/column-process-item.service';
import { ColumnProcessItem } from '../../column-process-item/column-process-item.types';
import { flow } from '../../flow/flow.data';
import { FlowService } from '../../flow/flow.service';
import { Flow } from '../../flow/flow.types';
import { Item } from '../../item/item.types';
import { LevelProfileOfficialService } from '../../level-profile/level-profile-official/level-profile-official.service';
import { LevelProfileOfficial } from '../../level-profile/level-profile-official/level-profile-official.types';
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
import { PluginItemColumnService } from '../../plugin-item/plugin-item-column/plugin-item-column.service';
import { PluginItemColumn } from '../../plugin-item/plugin-item-column/plugin-item-column.types';
import { PluginItemService } from '../../plugin-item/plugin-item.service';
import { PluginItem } from '../../plugin-item/plugin-item.types';
import { process } from '../../process/process.data';
import { ProcessService } from '../../process/process.service';
import { Process } from '../../process/process.types';
import { TemplateService } from '../../template/template.service';
import { Template } from '../../template/template.types';
import { ProcessCommentService } from '../components/process-comment/process-comment.service';
import { ProcessComment } from '../components/process-comment/process-comment.types';
import { ProcessItemService } from '../components/process-item/process-item.service';
import { ProcessItem } from '../components/process-item/process-item.types';
import { ModalTaskRealizeService } from '../modal-task-realize/modal-task-realize.service';
import { task } from '../task.data';
import { TaskService } from '../task.service';
import {
  Task,
  TYPE_STATUS_TASK,
  TYPE_STATUS_TASK_ENUM,
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
  _urlPathAvatar: string = environment.urlBackend + '/resource/img/avatar/';

  id_task: string = '';
  id_process: string = '';
  sourceProcess: boolean = false;
  isOfficialModifier: boolean = false;

  listProcess: Process[] = [];
  selectedProcess: Process = process;

  listOfficial: Official[] = [];
  selectedOfficial: Official = official;

  listLevel: Level[] = [];
  selectedLevel: Level = level;

  listFlow: Flow[] = [];
  selectedFlow: Flow = flow;

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
  task: Task = task;
  taskForm!: FormGroup;
  tasks!: Task[];

  processComment: ProcessComment[] = [];

  private _tagsPanelOverlayRef!: OverlayRef;
  private _unsubscribeAll: Subject<any> = new Subject<any>();
  /**
   * isOpenModal
   */
  isOpenModal: boolean = false;
  /**
   * isOpenModal
   */

  expansionForm!: FormGroup;

  listItem: Item[] = [];
  select_plugin_item: boolean = false;
  pluginItemColumns: PluginItemColumn[] = [];
  processItem: ProcessItem[] = [];
  isSelectedAllProcessItem: boolean = false;

  /**
   * Constructor
   */
  constructor(
    @Inject(MAT_DIALOG_DATA) public _data: any,
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
    private _flowService: FlowService,
    private _levelProfileService: LevelProfileService,
    private _levelStatusService: LevelStatusService,
    private _modalSelectOfficialByLevelProfileService: ModalSelectOfficialByLevelProfileService,
    private _globalUtils: GlobalUtils,
    private _modalTaskRealizeService: ModalTaskRealizeService,
    private _processCommentService: ProcessCommentService,
    private _templateService: TemplateService,
    private _pluginItemService: PluginItemService,
    private _pluginItemColumnService: PluginItemColumnService,
    private _processItemService: ProcessItemService,
    private _columnProcessItemService: ColumnProcessItemService,
    private _levelProfileOfficialService: LevelProfileOfficialService
  ) {}

  /** ----------------------------------------------------------------------------------------------------- */
  /** @ Lifecycle hooks
	  /** ----------------------------------------------------------------------------------------------------- */

  /**
   * On init
   */
  ngOnInit(): void {
    this.id_task = this._data.id_task;
    this.id_process = this._data.id_process;

    this.sourceProcess = this._data.sourceProcess;

    /**
     * form
     */
    this.expansionForm = this._formBuilder.group({
      tasks: this._formBuilder.array([]),

      processItems: this._formBuilder.array([]),
      // processControls: this._formBuilder.array([]),
      // processAttacheds: this._formBuilder.array([]),
    });

    (this.expansionForm.get('processItems') as FormArray).clear();
    // (this.expansionForm.get('processControls') as FormArray).clear();
    // (this.expansionForm.get('processAttacheds') as FormArray).clear();

    this._taskService
      .specificRead(this.id_task)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((task: Task) => {
        /**
         * Get the task
         */
        this.task = task;
        /**
         * Get the tasks
         */
        this._taskService
          .byProcessQueryRead(this.task.process.id_process, '*')
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe(() => {
            this._taskService.tasks$
              .pipe(takeUntil(this._unsubscribeAll))
              .subscribe((tasks: Task[]) => {
                this.tasks = tasks;
                /**
                 * FormArray Tasks
                 */
                /**
                 * Clear the tasks form arrays
                 */
                (this.expansionForm.get('tasks') as FormArray).clear();

                const lotTasksFormGroups: any = [];
                /**
                 * Iterate through them
                 */
                this.tasks.forEach((_task) => {
                  /**
                   * Get isOfficialModifier
                   */
                  this._levelProfileOfficialService
                    .byLevelProfileRead(
                      _task.level.level_profile.id_level_profile
                    )
                    .pipe(takeUntil(this._unsubscribeAll))
                    .subscribe(
                      (_levelProfileOfficials: LevelProfileOfficial[]) => {
                        var levelProfileOfficial: LevelProfileOfficial =
                          _levelProfileOfficials.find(
                            (item) =>
                              item.official.user.id_user ==
                              this.data.user.id_user
                          )!;

                        if (levelProfileOfficial) {
                          this.isOfficialModifier =
                            levelProfileOfficial.official_modifier;
                        }
                      }
                    );
                  /**
                   * Get officialModifier
                   */
                  /**
                   * Get template
                   */
                  this._templateService
                    .specificRead(_task.level.template.id_template)
                    .pipe(takeUntil(this._unsubscribeAll))
                    .subscribe((_template: Template) => {
                      console.log(_template);

                      let _select_plugin_item: boolean = false;
                      /**
                       * Render PluginItem
                       */
                      if (_template.plugin_item_process) {
                        /**
                         * Get the pluginItem
                         */
                        this._pluginItemService
                          .specificRead(_template.plugin_item.id_plugin_item)
                          .pipe(takeUntil(this._unsubscribeAll))
                          .subscribe((pluginItem: PluginItem) => {
                            _select_plugin_item = pluginItem.select_plugin_item;

                            /**
                             * Create a element form group
                             */
                            lotTasksFormGroups.push(
                              this._formBuilder.group({
                                id_task: _task.id_task,
                                process: [
                                  {
                                    value: _task.process,
                                    disabled: true,
                                  },
                                ],
                                official: [
                                  {
                                    value: _task.official,
                                    disabled: false,
                                  },
                                  [Validators.required],
                                ],
                                level: [
                                  {
                                    value: _task.level,
                                    disabled: false,
                                  },
                                  [Validators.required],
                                ],
                                number_task: [
                                  {
                                    value: _task.number_task,
                                    disabled: false,
                                  },
                                  [Validators.required],
                                ],
                                type_status_task: [
                                  {
                                    value: _task.type_status_task,
                                    disabled: false,
                                  },
                                  [Validators.required],
                                ],
                                date_task: [
                                  {
                                    value: _task.date_task,
                                    disabled: false,
                                  },
                                  [Validators.required],
                                ],
                                template: _template,
                                select_plugin_item: _select_plugin_item,
                                processItems: this._formBuilder.array([]),
                              })
                            );

                            this._pluginItemColumnService
                              .byPluginItemQueryRead(
                                _template.plugin_item.id_plugin_item,
                                '*'
                              )
                              .pipe(takeUntil(this._unsubscribeAll))
                              .subscribe(
                                (pluginItemColumn: PluginItemColumn[]) => {
                                  this.pluginItemColumns = pluginItemColumn;

                                  // ------------------------------------------------------------------------
                                  /**
                                   * ProcessItem byLevelRead
                                   */
                                  this._processItemService
                                    .byTaskRead(_task.id_task)
                                    .pipe(takeUntil(this._unsubscribeAll))
                                    .subscribe();
                                  /**
                                   * Get the processItems
                                   */
                                  this._processItemService.processItems$
                                    .pipe(takeUntil(this._unsubscribeAll))
                                    .subscribe(
                                      (_processItem: ProcessItem[]) => {
                                        console.log(_processItem);
                                        this.processItem = _processItem;
                                        if (
                                          this.processItem.length ==
                                          this.listItem.length
                                        ) {
                                          this.isSelectedAllProcessItem = true;
                                        } else {
                                          this.isSelectedAllProcessItem = false;
                                        }
                                        /**
                                         * Filter select
                                         */
                                        /**
                                         * Reset the selection
                                         * 1) add attribute isSelected
                                         * 2) [disabled]="entity.isSelected" in mat-option
                                         */
                                        this.listItem.map(
                                          (item: Item, index: number) => {
                                            item = {
                                              ...item,
                                              isSelected: false,
                                            };
                                            this.listItem[index] = item;
                                          }
                                        );

                                        let filterListItems: Item[] = cloneDeep(
                                          this.listItem
                                        );
                                        /**
                                         * Selected Items
                                         */
                                        this.processItem.map(
                                          (itemOne: ProcessItem) => {
                                            /**
                                             * All Items
                                             */
                                            filterListItems.map(
                                              (
                                                itemTwo: Item,
                                                index: number
                                              ) => {
                                                if (
                                                  itemTwo.id_item ==
                                                  itemOne.item!.id_item
                                                ) {
                                                  itemTwo = {
                                                    ...itemTwo,
                                                    isSelected: true,
                                                  };

                                                  filterListItems[index] =
                                                    itemTwo;
                                                }
                                              }
                                            );
                                          }
                                        );

                                        this.listItem = filterListItems;
                                        /**
                                         * Filter select
                                         */
                                        /**
                                         * Clear the processItems form arrays
                                         */
                                        (
                                          this.expansionForm.get(
                                            'processItems'
                                          ) as FormArray
                                        ).clear();

                                        const lotItemFormGroups: any = [];
                                        /**
                                         * Iterate through them
                                         */

                                        this.processItem.forEach(
                                          (
                                            _processItem: ProcessItem,
                                            indexOne: number
                                          ) => {
                                            /**
                                             * Crear los controles para los inputs horizontales
                                             */

                                            this.pluginItemColumns.forEach(
                                              async (
                                                _pluginItemColumn: PluginItemColumn
                                              ) => {
                                                /**
                                                 * Creamos los controles
                                                 */
                                                this.expansionForm.addControl(
                                                  `formControl${_pluginItemColumn.name_plugin_item_column}${indexOne}`,
                                                  new FormControl(
                                                    {
                                                      value: '',
                                                      disabled:
                                                        this.isOfficialModifier,
                                                    },
                                                    [
                                                      Validators.required,
                                                      Validators.maxLength(
                                                        _pluginItemColumn.lenght_plugin_item_column
                                                      ),
                                                    ]
                                                  )
                                                );
                                                /**
                                                 * Buscar el valor de la columna
                                                 */
                                                this._columnProcessItemService
                                                  .byPluginItemColumnAndProcessItemRead(
                                                    _pluginItemColumn.id_plugin_item_column,
                                                    _processItem.id_process_item
                                                  )
                                                  .pipe(
                                                    takeUntil(
                                                      this._unsubscribeAll
                                                    )
                                                  )
                                                  .subscribe(
                                                    (
                                                      columnProcessItem: ColumnProcessItem
                                                    ) => {
                                                      if (columnProcessItem) {
                                                        /**
                                                         * Creamos los controles
                                                         */
                                                        this.expansionForm.addControl(
                                                          `column${_pluginItemColumn.name_plugin_item_column}${indexOne}`,
                                                          new FormControl(
                                                            {
                                                              value:
                                                                columnProcessItem,
                                                              disabled:
                                                                this
                                                                  .isOfficialModifier,
                                                            },
                                                            [
                                                              Validators.required,
                                                            ]
                                                          )
                                                        );

                                                        this.expansionForm
                                                          .get(
                                                            `formControl${_pluginItemColumn.name_plugin_item_column}${indexOne}`
                                                          )
                                                          ?.patchValue(
                                                            columnProcessItem.value_column_process_item
                                                          );
                                                      }
                                                    }
                                                  );
                                              }
                                            );

                                            lotItemFormGroups.push(
                                              this._formBuilder.group({
                                                id_process_item:
                                                  _processItem.id_process_item,
                                                official: [
                                                  {
                                                    value:
                                                      _processItem.official,
                                                    disabled: false,
                                                  },
                                                  [Validators.required],
                                                ],
                                                process: [
                                                  {
                                                    value: _processItem.process,
                                                    disabled: false,
                                                  },
                                                  [Validators.required],
                                                ],
                                                task: [
                                                  {
                                                    value: _processItem.task,
                                                    disabled: false,
                                                  },
                                                  [Validators.required],
                                                ],
                                                level: [
                                                  {
                                                    value: _processItem.level,
                                                    disabled: false,
                                                  },
                                                  [Validators.required],
                                                ],
                                                item: [
                                                  {
                                                    value: _processItem.item,
                                                    disabled: false,
                                                  },
                                                  [Validators.required],
                                                ],
                                                id_item: [
                                                  {
                                                    value:
                                                      _processItem.item.id_item,
                                                    disabled:
                                                      this.processItem.length !=
                                                        indexOne + 1 ||
                                                      this
                                                        .isSelectedAllProcessItem,
                                                  },
                                                  [Validators.required],
                                                ],
                                                editMode: [
                                                  {
                                                    value: false,
                                                    disabled: false,
                                                  },
                                                ],
                                                isOwner: [
                                                  this.data.user.id_user ==
                                                    _processItem.official.user
                                                      .id_user,
                                                ],
                                              })
                                            );
                                          }
                                        );
                                        /**
                                         * Add the element form groups to the element form array
                                         */
                                        lotItemFormGroups.forEach(
                                          (_lotItemFormGroup: any) => {
                                            (
                                              this.expansionForm.get(
                                                'processItems'
                                              ) as FormArray
                                            ).push(_lotItemFormGroup);
                                          }
                                        );
                                      }
                                    );

                                  // ------------------------------------------------------------------------
                                }
                              );
                            /**
                             * Add the element form groups to the element form array
                             */
                            lotTasksFormGroups.forEach(
                              (lotTaskFormGroup: any) => {
                                (
                                  this.expansionForm.get('tasks') as FormArray
                                ).push(lotTaskFormGroup);
                              }
                            );
                          });
                      }
                      // /**
                      //  * Render PluginAttached
                      //  */
                      // if (_template.plugin_attached_process) {
                      // }
                    });
                });
                /**
                 * FormArray Tasks
                 */

                // this.tasks.map((_task: Task) => {
                //   if (_task.id_task != ' ') {
                //     console.log(_task.level.template.id_template);
                //     this._templateService
                //       .specificRead(_task.level.template.id_template)
                //       .pipe(takeUntil(this._unsubscribeAll))
                //       .subscribe((_template: Template) => {
                //         /**
                //          * Get the template
                //          */
                //         var template = _template;

                //         /**
                //          * Render PluginItem
                //          */

                //         // /**
                //         // * processControl byLevelRead
                //         // */
                //         // this._processControlService
                //         //   .byLevelRead(_task.level.id_level)
                //         //   .pipe(takeUntil(this._unsubscribeAll))
                //         //   .subscribe();
                //         // /**
                //         // * Subscribe byTemplateRead
                //         // */
                //         // if (
                //         //   template.id_template &&
                //         //   template.id_template != ' '
                //         // ) {
                //         //   this._templateControlService
                //         //     .byTemplateRead(template.id_template)
                //         //     .pipe(takeUntil(this._unsubscribeAll))
                //         //     .subscribe((_templateControl: TemplateControl[]) => {
                //         //       this.templateControl = _templateControl;
                //         //       /**
                //         //       * Get the processControls
                //         //       */
                //         //       this._processControlService.processControls$
                //         //         .pipe(takeUntil(this._unsubscribeAll))
                //         //         .subscribe((_processControl: ProcessControl[]) => {
                //         //           this.processControl = _processControl;
                //         //           /**
                //         //           * Clear the processControls form arrays
                //         //           */
                //         //           (
                //         //             this.expansionForm.get(
                //         //               'processControls'
                //         //             ) as FormArray
                //         //           ).clear();

                //         //           const lotControlFormGroups: any = [];

                //         //           /**
                //         //           * Iterate through them
                //         //           */
                //         //           this.templateControl.forEach((_templateControl) => {
                //         //             /**
                //         //             * Set controls
                //         //             */
                //         //             if (
                //         //               _templateControl.control.type_control === 'input' ||
                //         //               _templateControl.control.type_control ===
                //         //                 'textArea' ||
                //         //               _templateControl.control.type_control ===
                //         //                 'radioButton' ||
                //         //               _templateControl.control.type_control ===
                //         //                 'select' ||
                //         //               _templateControl.control.type_control === 'date'
                //         //             ) {
                //         //               this.expansionForm.addControl(
                //         //                 _templateControl.control.form_name_control,
                //         //                 new FormControl(
                //         //                   {
                //         //                     value:
                //         //                       _templateControl.control
                //         //                         .initial_value_control,
                //         //                     disabled: this.isOfficialModifier,
                //         //                   },
                //         //                   [
                //         //                     _templateControl.control.required_control
                //         //                       ? Validators.required
                //         //                       : Validators.min(0),
                //         //                   ]
                //         //                 )
                //         //               );
                //         //             } else if (
                //         //               _templateControl.control.type_control === 'checkBox'
                //         //             ) {
                //         //               _templateControl.control.options_control.map(
                //         //                 (item: any) => {
                //         //                   this.expansionForm.addControl(
                //         //                     `${_templateControl.control.form_name_control}${item.value}`,
                //         //                     new FormControl(null)
                //         //                   );
                //         //                 }
                //         //               );
                //         //             } else if (
                //         //               _templateControl.control.type_control ===
                //         //               'dateRange'
                //         //             ) {
                //         //               this.expansionForm.addControl(
                //         //                 `${_templateControl.control.form_name_control}StartDate`,
                //         //                 new FormControl(
                //         //                   {
                //         //                     value:
                //         //                       _templateControl.control
                //         //                         .initial_value_control,
                //         //                     disabled: this.isOfficialModifier,
                //         //                   },
                //         //                   [
                //         //                     _templateControl.control.required_control
                //         //                       ? Validators.required
                //         //                       : Validators.min(0),
                //         //                   ]
                //         //                 )
                //         //               );
                //         //               this.expansionForm.addControl(
                //         //                 `${_templateControl.control.form_name_control}EndDate`,
                //         //                 new FormControl(
                //         //                   {
                //         //                     value:
                //         //                       _templateControl.control
                //         //                         .initial_value_control,
                //         //                     disabled: this.isOfficialModifier,
                //         //                   },
                //         //                   [
                //         //                     _templateControl.control.required_control
                //         //                       ? Validators.required
                //         //                       : Validators.min(0),
                //         //                   ]
                //         //                 )
                //         //               );
                //         //             }
                //         //             /**
                //         //             * Set controls
                //         //             */
                //         //             let _processControl: ProcessControl =
                //         //               this.processControl.find(
                //         //                 (_processControl: ProcessControl) =>
                //         //                   _processControl.control.id_control ===
                //         //                   _templateControl.control.id_control
                //         //               )!;

                //         //             if (_processControl) {
                //         //               if (
                //         //                 _templateControl.control.type_control ===
                //         //                   'input' ||
                //         //                 _templateControl.control.type_control ===
                //         //                   'textArea' ||
                //         //                 _templateControl.control.type_control ===
                //         //                   'radioButton' ||
                //         //                 _templateControl.control.type_control ===
                //         //                   'select' ||
                //         //                 _templateControl.control.type_control === 'date'
                //         //               ) {
                //         //                 this.expansionForm
                //         //                   .get(_templateControl.control.form_name_control)
                //         //                   ?.patchValue(
                //         //                     _processControl.value_process_control
                //         //                   );
                //         //               } else if (
                //         //                 _templateControl.control.type_control ===
                //         //                 'checkBox'
                //         //               ) {
                //         //                 _templateControl.control.options_control.map(
                //         //                   (option: any) => {
                //         //                     const _form_name_control = `${_templateControl.control.form_name_control}${option.value}`;
                //         //                     let checkeds: string[] = [];

                //         //                     if (
                //         //                       _processControl.value_process_control !=
                //         //                         undefined &&
                //         //                       _processControl.value_process_control !=
                //         //                         'undefined' &&
                //         //                       _processControl.value_process_control !=
                //         //                         ' ' &&
                //         //                       _processControl.value_process_control !=
                //         //                         null
                //         //                     ) {
                //         //                       checkeds = JSON.parse(
                //         //                         _processControl.value_process_control
                //         //                       );
                //         //                     }

                //         //                     const isChecked = checkeds.find(
                //         //                       (item: string) =>
                //         //                         item === _form_name_control
                //         //                     );

                //         //                     this.expansionForm
                //         //                       .get(_form_name_control)
                //         //                       ?.patchValue(isChecked ? true : null);
                //         //                   }
                //         //                 );
                //         //               } else if (
                //         //                 _templateControl.control.type_control ===
                //         //                 'dateRange'
                //         //               ) {
                //         //                 let value: any;
                //         //                 let startDate: string = '';
                //         //                 let endDate: string = '';

                //         //                 if (
                //         //                   _processControl.value_process_control !=
                //         //                     undefined &&
                //         //                   _processControl.value_process_control !=
                //         //                     'undefined' &&
                //         //                   _processControl.value_process_control != ' ' &&
                //         //                   _processControl.value_process_control != null
                //         //                 ) {
                //         //                   value = JSON.parse(
                //         //                     _processControl.value_process_control
                //         //                   );

                //         //                   startDate = value.startDate;
                //         //                   endDate = value.endDate;
                //         //                 }

                //         //                 /**
                //         //                 * Set values date
                //         //                 */
                //         //                 this.expansionForm
                //         //                   .get(
                //         //                     `${_templateControl.control.form_name_control}StartDate`
                //         //                   )
                //         //                   ?.patchValue(startDate);

                //         //                 this.expansionForm
                //         //                   .get(
                //         //                     `${_templateControl.control.form_name_control}EndDate`
                //         //                   )
                //         //                   ?.patchValue(endDate);
                //         //               }
                //         //               /**
                //         //               * Set the value if haved
                //         //               */
                //         //             } else {
                //         //               _processControl = this._processControl;
                //         //             }
                //         //             /**
                //         //             * Create an element form group
                //         //             */
                //         //             lotControlFormGroups.push(
                //         //               this._formBuilder.group({
                //         //                 id_template_control:
                //         //                   _templateControl.id_template_control,
                //         //                 template: _templateControl.template,
                //         //                 control: _templateControl.control,
                //         //                 ordinal_position:
                //         //                   _templateControl.ordinal_position,
                //         //                 /**
                //         //                 * Upload properties
                //         //                 */
                //         //                 isComplete:
                //         //                   _processControl.id_process_control != ' '
                //         //                     ? true
                //         //                     : false,
                //         //                 id_process_control: _processControl
                //         //                   ? _processControl.id_process_control
                //         //                   : '',
                //         //                 official: _processControl
                //         //                   ? _processControl.official
                //         //                   : '',
                //         //                 process: _processControl
                //         //                   ? _processControl.process
                //         //                   : '',
                //         //                 task: _processControl ? _processControl.task : '',
                //         //                 level: _processControl
                //         //                   ? _processControl.level
                //         //                   : '',
                //         //                 value_process_control: _processControl
                //         //                   ? _processControl.value_process_control
                //         //                   : '',
                //         //                 last_change_process_control: _processControl
                //         //                   ? _processControl.last_change_process_control
                //         //                   : '',
                //         //                 isOwner: [
                //         //                   this.data.user.id_user ==
                //         //                     _processControl.official.user.id_user,
                //         //                 ],
                //         //               })
                //         //             );
                //         //           });
                //         //           /**
                //         //           * Add the element form groups to the element form array
                //         //           */
                //         //           lotControlFormGroups.forEach(
                //         //             (_lotControlFormGroup: any) => {
                //         //               (
                //         //                 this.expansionForm.get(
                //         //                   'processControls'
                //         //                 ) as FormArray
                //         //               ).push(_lotControlFormGroup);
                //         //             }
                //         //           );
                //         //         });
                //         //     });
                //         // }

                //         // /**
                //         // * Attached
                //         // */
                //         // if (template.plugin_attached_process) {
                //         //   /**
                //         //   * processAttached byLevelRead
                //         //   */
                //         //   this._processAttachedService
                //         //     .byTaskRead(_task.id_task)
                //         //     .pipe(takeUntil(this._unsubscribeAll))
                //         //     .subscribe();
                //         //   /**
                //         //   * Render plugin_attached_process
                //         //   */
                //         //   this._documentationProfileAttachedService
                //         //     .byDocumentationProfileRead(
                //         //       template.documentation_profile.id_documentation_profile
                //         //     )
                //         //     .pipe(takeUntil(this._unsubscribeAll))
                //         //     .subscribe(
                //         //       (
                //         //         _documentationProfileAttacheds: DocumentationProfileAttached[]
                //         //       ) => {
                //         //         this.documentationProfileAttacheds =
                //         //           _documentationProfileAttacheds;
                //         //         /**
                //         //         * Get the processAttacheds
                //         //         */
                //         //         this._processAttachedService.processAttacheds$
                //         //           .pipe(takeUntil(this._unsubscribeAll))
                //         //           .subscribe((_processAttached: ProcessAttached[]) => {
                //         //             this.processAttached = _processAttached;
                //         //             /**
                //         //             * Clear the lotAttached form arrays
                //         //             */
                //         //             (
                //         //               this.expansionForm.get(
                //         //                 'processAttacheds'
                //         //               ) as FormArray
                //         //             ).clear();

                //         //             const lotAttachedFormGroups: any = [];
                //         //             /**
                //         //             * Iterate through them
                //         //             */
                //         //             this.documentationProfileAttacheds.forEach(
                //         //               (
                //         //                 _documentationProfileAttached: DocumentationProfileAttached,
                //         //                 index: number
                //         //               ) => {
                //         //                 /**
                //         //                 * Add control for the input file
                //         //                 */
                //         //                 this.expansionForm.addControl(
                //         //                   'removablefile' + index,
                //         //                   new FormControl(
                //         //                     {
                //         //                       value: '',
                //         //                       disabled: this.isOfficialModifier,
                //         //                     },
                //         //                     [
                //         //                       FileValidator.maxContentSize(
                //         //                         _documentationProfileAttached.attached
                //         //                           .length_mb_attached *
                //         //                           1024 *
                //         //                           1024
                //         //                       ),
                //         //                       _documentationProfileAttached.attached
                //         //                         .required_attached
                //         //                         ? Validators.required
                //         //                         : Validators.min(0),
                //         //                     ]
                //         //                   )
                //         //                 );
                //         //                 let _processAttached: ProcessAttached =
                //         //                   this.processAttached.find(
                //         //                     (_processAttached: ProcessAttached) =>
                //         //                       _processAttached.attached.id_attached ===
                //         //                       _documentationProfileAttached.attached
                //         //                         .id_attached
                //         //                   )!;

                //         //                 let _matTooltip = ``;

                //         //                 if (_processAttached) {
                //         //                   /**
                //         //                   * Creamos un objeto file para ponerlo dentro del imput para que no lo puedan remplazar
                //         //                   */

                //         //                   const file = new File(
                //         //                     ['attached'],
                //         //                     this.getNameFile(
                //         //                       _processAttached.server_path
                //         //                     ),
                //         //                     {
                //         //                       type: 'application/pdf',
                //         //                     }
                //         //                   );

                //         //                   this.expansionForm
                //         //                     .get('removablefile' + index)
                //         //                     ?.patchValue(new FileInput([file]));
                //         //                   /**
                //         //                   * Verificar si la tarea esta enviada  y bloquear removablefile + index
                //         //                   */
                //         //                   if (this.isOfficialModifier) {
                //         //                     this.expansionForm
                //         //                       .get('removablefile' + index)
                //         //                       ?.disable();
                //         //                   }
                //         //                   /**
                //         //                   * Set _matTooltip
                //         //                   */
                //         //                   _matTooltip = `${_processAttached.length_mb} MB`;
                //         //                 } else {
                //         //                   _processAttached = this._processAttached;
                //         //                 }

                //         //                 /**
                //         //                 * Create a element form group
                //         //                 */
                //         //                 lotAttachedFormGroups.push(
                //         //                   this._formBuilder.group({
                //         //                     id_documentation_profile_attached:
                //         //                       _documentationProfileAttached.id_documentation_profile_attached,
                //         //                     id_attached:
                //         //                       _documentationProfileAttached.attached
                //         //                         .id_attached,
                //         //                     name_attached:
                //         //                       _documentationProfileAttached.attached
                //         //                         .name_attached,
                //         //                     description_attached:
                //         //                       _documentationProfileAttached.attached
                //         //                         .description_attached,
                //         //                     length_mb_attached:
                //         //                       _documentationProfileAttached.attached
                //         //                         .length_mb_attached,
                //         //                     required_attached:
                //         //                       _documentationProfileAttached.attached
                //         //                         .required_attached,
                //         //                     documentation_profile:
                //         //                       _documentationProfileAttached.documentation_profile,
                //         //                     matTooltip: _matTooltip,
                //         //                     /**
                //         //                     * Upload properties
                //         //                     */
                //         //                     isUpload:
                //         //                       _processAttached.id_process_attached != ' '
                //         //                         ? true
                //         //                         : false,
                //         //                     id_process_attached: _processAttached
                //         //                       ? _processAttached.id_process_attached
                //         //                       : '',
                //         //                     official: _processAttached
                //         //                       ? _processAttached.official
                //         //                       : '',
                //         //                     process: _processAttached
                //         //                       ? _processAttached.process
                //         //                       : '',
                //         //                     task: _processAttached
                //         //                       ? _processAttached.task
                //         //                       : '',
                //         //                     level: _processAttached
                //         //                       ? _processAttached.level
                //         //                       : '',
                //         //                     attached: _processAttached
                //         //                       ? _processAttached.attached
                //         //                       : '',
                //         //                     file_name: [
                //         //                       _processAttached.file_name != ' ' &&
                //         //                       _processAttached.file_name != null &&
                //         //                       _processAttached.file_name != undefined
                //         //                         ? _processAttached.file_name
                //         //                         : '',
                //         //                       _documentationProfileAttached.attached
                //         //                         .required_attached
                //         //                         ? Validators.required
                //         //                         : Validators.min(0),
                //         //                     ],
                //         //                     length_mb: _processAttached
                //         //                       ? _processAttached.length_mb
                //         //                       : '',
                //         //                     extension: _processAttached
                //         //                       ? _processAttached.extension
                //         //                       : '',
                //         //                     server_path: _processAttached
                //         //                       ? _processAttached.server_path
                //         //                       : '',
                //         //                     alfresco_path: _processAttached
                //         //                       ? _processAttached.alfresco_path
                //         //                       : '',
                //         //                     upload_date: _processAttached
                //         //                       ? _processAttached.upload_date
                //         //                       : '',
                //         //                     isOwner: [
                //         //                       this.data.user.id_user ==
                //         //                         _processAttached.official.user.id_user,
                //         //                     ],
                //         //                   })
                //         //                 );
                //         //               }
                //         //             );
                //         //             /**
                //         //             * Add the element form groups to the element form array
                //         //             */
                //         //             lotAttachedFormGroups.forEach(
                //         //               (lotAttachedFormGroup: any) => {
                //         //                 (
                //         //                   this.expansionForm.get(
                //         //                     'processAttacheds'
                //         //                   ) as FormArray
                //         //                 ).push(lotAttachedFormGroup);
                //         //               }
                //         //             );
                //         //           });
                //         //       }
                //         //     );
                //         // }
                //         /**
                //          * Mark for check
                //          */
                //         this._changeDetectorRef.markForCheck();
                //       });
                //   }
                // });

                /**
                 * Mark for check
                 */
                this._changeDetectorRef.markForCheck();
              });
          });

        if (this.sourceProcess) {
          /**
           * opentask
           */
          this.openModalTaskRealize();
        }
      });
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
      number_task: ['', [Validators.required]],
      type_status_task: ['', [Validators.required]],
      date_task: ['', [Validators.required]],
      processComments: this._formBuilder.array([]),
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

        if (this.task.id_task != ' ') {
          this._processCommentService
            .byProcessRead(this.task.process.id_process)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe();

          this._processCommentService.processComments$
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe((_processComment: ProcessComment[]) => {
              this.processComment = _processComment;
              /**
               * Clear the processComments form arrays
               */
              (this.taskForm.get('processComments') as FormArray).clear();

              const lotCommentFormGroups: any = [];
              /**
               * Iterate through them
               */

              this.processComment.forEach((_processComment) => {
                /**
                 * Create an elemento form group
                 */

                lotCommentFormGroups.push(
                  this._formBuilder.group({
                    id_process_comment: _processComment.id_process_comment,
                    value_process_comment: [
                      {
                        value: _processComment.value_process_comment,
                        disabled: true,
                      },
                    ],
                    date_process_comment: [
                      {
                        value: _processComment.date_process_comment,
                        disabled: false,
                      },
                      [Validators.required],
                    ],
                    official: [
                      {
                        value: _processComment.official,
                        disabled: false,
                      },
                      [Validators.required],
                    ],
                    process: [
                      {
                        value: _processComment.process,
                        disabled: false,
                      },
                      [Validators.required],
                    ],
                    task: [
                      {
                        value: _processComment.task,
                        disabled: false,
                      },
                      [Validators.required],
                    ],
                    level: [
                      {
                        value: _processComment.level,
                        disabled: false,
                      },
                      [Validators.required],
                    ],
                    editMode: [
                      {
                        value: false,
                        disabled: false,
                      },
                    ],
                    isOwner: [
                      this.data.user.id_user ==
                        _processComment.official.user.id_user,
                    ],
                  })
                );
              });
              /**
               * Add the elemento form groups to the elemento form array
               */
              lotCommentFormGroups.forEach((lotCommentFormGroup: any) => {
                (this.taskForm.get('processComments') as FormArray).push(
                  lotCommentFormGroup
                );
              });
            });

          /**
           * Type Enum TYPE_STATUS_TAKS
           */
          this.typeStatusTaskSelect = this.typeStatusTask.find(
            (type_status) =>
              type_status.value_type == this.task.type_status_task
          )!;
          /**
           * Type Enum TYPE_STATUS_TAKS
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

          // Flow
          this._flowService
            .byCompanyQueryRead(this.id_company, '*')
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe((flows: Flow[]) => {
              this.listFlow = flows;

              this.selectedFlow = this.listFlow.find(
                (item) =>
                  item.id_flow ==
                  this.task.process.flow_version.flow.id_flow.toString()
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
        }
      });
  }

  get formArrayTasks(): FormArray {
    return this.expansionForm.get('tasks') as FormArray;
  }

  get formArrayProcessItems(): FormArray {
    return this.expansionForm.get('processItems') as FormArray;
  }

  get formArrayProcessComments(): FormArray {
    return this.taskForm.get('processComments') as FormArray;
  }
  /**
   * getFromControl
   * @param formArray
   * @param index
   * @param control
   * @returns
   */
  getFromControl(
    formArray: FormArray,
    index: number,
    control: string
  ): FormControl {
    return formArray.controls[index].get(control) as FormControl;
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

  /**
   * createProcessItem
   */
  createProcessItem() {
    const id_user_ = this.data.user.id_user;
    const id_official: string = this.task.official.id_official;
    const id_process: string = this.task.process.id_process;
    const id_task: string = this.task.id_task;
    const id_level: string = this.task.level.id_level;

    this._processItemService
      .create(id_user_, id_official, id_process, id_task, id_level)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_processItem: ProcessItem) => {
          if (_processItem) {
            const index = this.processItem.findIndex(
              (_processItem) =>
                _processItem.id_process_item == _processItem.id_process_item
            );

            this._notificationService.success('Item agregado correctamente');
          } else {
            this._notificationService.error('Ocurrió un error agregar el item');
          }
          /**
           * Mark for check
           */
          this._changeDetectorRef.markForCheck();
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
   * updateProcessItem
   * @param index
   */
  updateProcessItem(index: number) {
    const id_user_ = this.data.user.id_user;
    const elementProcessItemFormArray = this.expansionForm.get(
      'processItems'
    ) as FormArray;

    let processItem = elementProcessItemFormArray.getRawValue()[index];

    processItem = {
      ...processItem,
      id_user_: parseInt(id_user_),
      id_process_item: parseInt(processItem.id_process_item),
      official: {
        id_official: parseInt(this.task.official.id_official),
      },
      process: {
        id_process: parseInt(processItem.process.id_process),
      },
      task: {
        id_task: parseInt(processItem.task.id_task),
      },
      level: {
        id_level: parseInt(processItem.level.id_level),
      },
      item: {
        id_item: parseInt(processItem.item.id_item),
      },
    };

    this._processItemService
      .update(processItem)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_processItem: ProcessItem) => {
          if (_processItem) {
            this._notificationService.success('Item actualizado');
          } else {
            this._notificationService.error(
              'Ocurrió un error al actualiar el item'
            );
          }
          /**
           * Mark for check
           */
          this._changeDetectorRef.markForCheck();
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
   * deleteProcessItem
   * @param index
   */
  deleteProcessItem(index: number, pluginItemColumns: PluginItemColumn[]) {
    const elementProcessItemFormArray = this.expansionForm.get(
      'processItems'
    ) as FormArray;
    /**
     * Delete control of columns
     */
    pluginItemColumns.forEach((pluginItemColumn: PluginItemColumn) => {
      this.expansionForm.removeControl(
        `formControl${pluginItemColumn.name_plugin_item_column}${index}`
      );
      this.expansionForm.removeControl(
        `column${pluginItemColumn.name_plugin_item_column}${index}`
      );
    });

    const id_process_item =
      elementProcessItemFormArray.getRawValue()[index].id_process_item;
    const id_user_ = this.data.user.id_user;

    this._processItemService
      .delete(id_user_, id_process_item)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (response: boolean) => {
          if (response) {
            this._notificationService.success('Item eliminado');
          } else {
            this._notificationService.error(
              'Ocurrió un error eliminado el item'
            );
          }
          /**
           * Mark for check
           */
          this._changeDetectorRef.markForCheck();
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
   * Update the columnProcessItem
   */
  updateColumnProcessItem(
    name_plugin_item_column: string,
    index: number,
    column: PluginItemColumn
  ): void {
    const elementProcessItemFormArray = this.expansionForm.get(
      'processItems'
    ) as FormArray;

    let processItem = elementProcessItemFormArray.getRawValue()[index];

    const id_user_ = this.data.user.id_user;
    const formControl = this.expansionForm.get(
      `formControl${name_plugin_item_column}${index}`
    );

    const hasErrorLength: boolean = formControl?.hasError('maxlength')!;

    const valueFormControl = formControl?.value;
    /**
     * Get the columnProcessItem
     */
    let columnProcessItem = this.expansionForm.get(
      `column${name_plugin_item_column}${index}`
    )?.value;

    if (!hasErrorLength) {
      if (columnProcessItem) {
        /**
         * Delete whitespace (trim() the atributes type string)
         */
        columnProcessItem = {
          ...columnProcessItem,
          id_user_: parseInt(id_user_),
          id_column_process_item: parseInt(
            columnProcessItem.id_column_process_item
          ),
          plugin_item_column: {
            id_plugin_item_column: parseInt(
              columnProcessItem.plugin_item_column.id_plugin_item_column
            ),
          },
          process_item: {
            id_process_item: parseInt(
              columnProcessItem.process_item.id_process_item
            ),
          },
          value_column_process_item: valueFormControl,
        };
        /**
         * Update
         */
        this._columnProcessItemService
          .update(columnProcessItem)
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe({
            next: (_columnProcessItem: ColumnProcessItem) => {
              if (_columnProcessItem) {
                this._notificationService.success(
                  'Column process item actualizada correctamente'
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
      } else {
        /**
         * Create the column_process_item
         */
        this._columnProcessItemService
          .create(
            id_user_,
            column.id_plugin_item_column,
            processItem.id_process_item,
            valueFormControl
          )
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe({
            next: (_columnProcessItem: ColumnProcessItem) => {
              if (_columnProcessItem) {
                this._notificationService.success(
                  'Column process item agregada correctamente'
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
      this._processItemService.$processItems = this.processItem;
    } else {
      this._notificationService.error(`
          La columna 
          ${column.name_plugin_item_column} en la fila ${index + 1} ha
          excedido los caracteres máximos (${column.lenght_plugin_item_column}
          caracteres)`);
    }
  }
  /** ----------------------------------------------------------------------------------------------------- */
  /** @ Public methods
      /** ----------------------------------------------------------------------------------------------------- */
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
   * addProcessComment
   */
  addProcessComment() {
    const id_user_ = this.data.user.id_user;
    const id_official: string = this.task.official.id_official;
    const id_process: string = this.task.process.id_process;
    const id_task: string = this.task.id_task;
    const id_level: string = this.task.level.id_level;

    this._processCommentService
      .create(id_user_, id_official, id_process, id_task, id_level)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_processComment: ProcessComment) => {
          if (_processComment) {
            const index = this.processComment.findIndex(
              (_processComment) =>
                _processComment.id_process_comment ==
                _processComment.id_process_comment
            );

            this.editProcessComment(index, true);

            this._notificationService.success(
              'Comentario agregado correctamente'
            );
          } else {
            this._notificationService.error(
              'Ocurrió un error agregar el comentario'
            );
          }
          /**
           * Mark for check
           */
          this._changeDetectorRef.markForCheck();
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
   * editProcessComment
   * @param index
   * @param status
   */
  editProcessComment(index: number, status: boolean) {
    if (status) {
      this.desactiveAllControl();
      /**
       * set edit mode
       */
      this.getFromControl(
        this.formArrayProcessComments,
        index,
        'editMode'
      ).patchValue(status);
      /**
       * Enabled control
       */
      this.getFromControl(
        this.formArrayProcessComments,
        index,
        'value_process_comment'
      ).enable();
    } else {
      this.getFromControl(
        this.formArrayProcessComments,
        index,
        'editMode'
      ).patchValue(status);
      /**
       * Enabled control
       */
      this.getFromControl(
        this.formArrayProcessComments,
        index,
        'value_process_comment'
      ).disable();
    }
  }
  /**
   * desactiveAllControl
   */
  desactiveAllControl() {
    this.processComment.map((item: ProcessComment, index: number) => {
      this.getFromControl(
        this.formArrayProcessComments,
        index,
        'editMode'
      ).patchValue(false);
      /**
       * Enabled control
       */
      this.getFromControl(
        this.formArrayProcessComments,
        index,
        'value_process_comment'
      ).disable();
    });
  }
  /**
   * saveProcessComment
   * @param index
   */
  saveProcessComment(index: number) {
    this.editProcessComment(index, false);

    const id_user_ = this.data.user.id_user;
    const elementProcessCommentFormArray = this.taskForm.get(
      'processComments'
    ) as FormArray;

    let processComment = elementProcessCommentFormArray.getRawValue()[index];

    processComment = {
      ...processComment,
      id_user_: parseInt(id_user_),
      id_process_comment: parseInt(processComment.id_process_comment),
      official: {
        id_official: parseInt(processComment.official.id_official),
      },
      process: {
        id_process: parseInt(processComment.process.id_process),
      },
      task: {
        id_task: parseInt(processComment.task.id_task),
      },
      level: {
        id_level: parseInt(processComment.level.id_level),
      },
      value_process_comment: processComment.value_process_comment.trim(),
    };

    this._processCommentService
      .update(processComment)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_processComment: ProcessComment) => {
          if (_processComment) {
            this._notificationService.success('Comentario actualizado');
          } else {
            this._notificationService.error(
              'Ocurrió un error al actualiar el comentario'
            );
          }
          /**
           * Mark for check
           */
          this._changeDetectorRef.markForCheck();
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
   * deleteProcessComment
   * @param index
   */
  deleteProcessComment(index: number) {
    const elementProcessCommentFormArray = this.taskForm.get(
      'processComments'
    ) as FormArray;

    const id_process_comment =
      elementProcessCommentFormArray.getRawValue()[index].id_process_comment;
    const id_user_ = this.data.user.id_user;

    this._processCommentService
      .delete(id_user_, id_process_comment)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (response: boolean) => {
          if (response) {
            this._notificationService.success('Comentario eliminado');
          } else {
            this._notificationService.error(
              'Ocurrió un error eliminado el comentario'
            );
          }
          /**
           * Mark for check
           */
          this._changeDetectorRef.markForCheck();
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
   * openModalTaskRealize
   */
  openModalTaskRealize(): void {
    this._modalTaskRealizeService.openModalTaskRealize(
      this.task.id_task,
      this.task.level.template.id_template
    );
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
   * closeModalTask
   */
  closeModalTask(): void {
    this._modalTaskService.closeModalTask();
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
