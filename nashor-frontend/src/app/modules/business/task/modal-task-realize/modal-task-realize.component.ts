import { angelAnimations } from '@angel/animations';
import { AngelAlertType } from '@angel/components/alert';
import { ChangeDetectorRef, Component, Inject, OnInit } from '@angular/core';
import {
  FormArray,
  FormBuilder,
  FormControl,
  FormGroup,
  Validators,
} from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Store } from '@ngrx/store';
import { AppInitialData, MessageAPI } from 'app/core/app/app.type';
import { LayoutService } from 'app/layout/layout.service';
import { NotificationService } from 'app/shared/notification/notification.service';
import { environment } from 'environments/environment';
import { saveAs } from 'file-saver';
import { cloneDeep } from 'lodash';
import { FileInput, FileValidator } from 'ngx-material-file-input';
import { Subject, takeUntil } from 'rxjs';
import { DocumentationProfileAttachedService } from '../../documentation-profile/documentation-profile-attached/documentation-profile-attached.service';
import { DocumentationProfileAttached } from '../../documentation-profile/documentation-profile-attached/documentation-profile-attached.types';
import { documentationProfile } from '../../documentation-profile/documentation-profile.data';
import { DocumentationProfile } from '../../documentation-profile/documentation-profile.types';
import { ItemService } from '../../item/item.service';
import { Item } from '../../item/item.types';
import { TemplateControlService } from '../../template/template-control/template-control.service';
import { TemplateControl } from '../../template/template-control/template-control.types';
import { TemplateService } from '../../template/template.service';
import { Template } from '../../template/template.types';
import { processAttached } from '../components/process-attached/process-attached.data';
import { ProcessAttachedService } from '../components/process-attached/process-attached.service';
import { ProcessAttached } from '../components/process-attached/process-attached.types';
import { ProcessControlService } from '../components/process-control/process-control.service';
import { ProcessControl } from '../components/process-control/process-control.types';
import { ProcessItemService } from '../components/process-item/process-item.service';
import { ProcessItem } from '../components/process-item/process-item.types';
import { Task } from '../task.types';
import { ModalTaskRealizeService } from './modal-task-realize.service';

@Component({
  selector: 'app-modal-task-realize',
  templateUrl: './modal-task-realize.component.html',
  animations: angelAnimations,
})
export class ModalTaskRealizeComponent implements OnInit {
  _urlPathAvatar: string = environment.urlBackend + '/resource/img/avatar/';

  task!: Task;
  id_template: string = '';
  taskRealizeForm!: FormGroup;
  id_company: string = '';

  listDocumentationProfile: DocumentationProfile[] = [];
  selectedDocumentationProfile: DocumentationProfile = documentationProfile;

  listItem: Item[] = [];

  private _unsubscribeAll: Subject<any> = new Subject<any>();

  template!: Template;
  private data!: AppInitialData;

  templateControl!: TemplateControl[];

  processItem: ProcessItem[] = [];
  processControl: ProcessControl[] = [];
  processAttached: ProcessAttached[] = [];

  isSelectedAllProcessItem: boolean = false;

  _processAttached: ProcessAttached = processAttached;
  documentationProfileAttacheds: DocumentationProfileAttached[] = [];

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
  /**
   * isOpenModal
   */
  isOpenModal: boolean = false;
  /**
   * isOpenModal
   */
  constructor(
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _store: Store<{ global: AppInitialData }>,
    private _formBuilder: FormBuilder,
    private _modalTaskRealizeService: ModalTaskRealizeService,
    private _changeDetectorRef: ChangeDetectorRef,
    private _layoutService: LayoutService,
    private _templateService: TemplateService,
    private _templateControlService: TemplateControlService,
    private _documentationProfileAttachedService: DocumentationProfileAttachedService,
    private _itemService: ItemService,
    private _processItemService: ProcessItemService,
    private _processControlService: ProcessControlService,
    private _processAttachedService: ProcessAttachedService,
    private _notificationService: NotificationService
  ) {}

  ngOnInit(): void {
    this.task = this._data.task;
    this.id_template = this._data.id_template;

    /**
     * readAllItem
     */
    this._itemService
      .queryRead('*')
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((items: Item[]) => {
        this.listItem = items;
      });

    /**
     * Subscribe to user changes of state
     */
    this._store.pipe(takeUntil(this._unsubscribeAll)).subscribe((state) => {
      this.data = state.global;
      this.id_company = this.data.user.company.id_company;
    });
    /**
     * form
     */
    this.taskRealizeForm = this._formBuilder.group({
      processItems: this._formBuilder.array([]),
      processControls: this._formBuilder.array([]),
      processAttacheds: this._formBuilder.array([]),
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
     * Get the template
     */
    this._templateService
      .specificRead(this.id_template)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe();
    /**
     * Get the template
     */
    this._templateService.template$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_template: Template) => {
        /**
         * Get the template
         */
        this.template = _template;
        /**
         * processControl byLevelRead
         */
        this._processControlService
          .byLevelRead(this.task.level.id_level)
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe();
        /**
         * Subscribe byTemplateRead
         */
        if (this.template.id_template && this.template.id_template != ' ') {
          this._templateControlService
            .byTemplateRead(this.template.id_template)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe((_templateControl: TemplateControl[]) => {
              this.templateControl = _templateControl;
              console.log(this.templateControl);
              /**
               * Set controls
               */
              this.templateControl.map((_templateControl: any) => {
                if (
                  _templateControl.control.type_control === 'input' ||
                  _templateControl.control.type_control === 'textArea' ||
                  _templateControl.control.type_control === 'radioButton' ||
                  _templateControl.control.type_control === 'select' ||
                  _templateControl.control.type_control === 'date'
                ) {
                  this.taskRealizeForm.addControl(
                    _templateControl.control.form_name_control,
                    new FormControl(
                      _templateControl.control.initial_value_control,
                      [
                        _templateControl.control.required_control
                          ? Validators.required
                          : Validators.min(0),
                      ]
                    )
                  );
                } else if (
                  _templateControl.control.type_control === 'checkBox'
                ) {
                  _templateControl.control.options_control.map((item: any) => {
                    this.taskRealizeForm.addControl(
                      `${_templateControl.control.form_name_control}${item.value}`,
                      new FormControl(null)
                    );
                  });
                } else if (
                  _templateControl.control.type_control === 'dateRange'
                ) {
                  this.taskRealizeForm.addControl(
                    `${_templateControl.control.form_name_control}StartDate`,
                    new FormControl(
                      _templateControl.control.initial_value_control,
                      [
                        _templateControl.control.required_control
                          ? Validators.required
                          : Validators.min(0),
                      ]
                    )
                  );
                  this.taskRealizeForm.addControl(
                    `${_templateControl.control.form_name_control}EndDate`,
                    new FormControl(
                      _templateControl.control.initial_value_control,
                      [
                        _templateControl.control.required_control
                          ? Validators.required
                          : Validators.min(0),
                      ]
                    )
                  );
                }
              });
              /**
               * Set controls
               */
              /**
               * Get the processControls
               */
              this._processControlService.processControls$
                .pipe(takeUntil(this._unsubscribeAll))
                .subscribe((_processControl: ProcessControl[]) => {
                  this.processControl = _processControl;
                  if (this.processControl.length > 0) {
                    console.log(this.processControl);
                  }

                  /**
                   * Clear the processControls form arrays
                   */
                  (
                    this.taskRealizeForm.get('processControls') as FormArray
                  ).clear();

                  const lotControlFormGroups: any = [];
                  /**
                   * Iterate through them
                   */

                  this.processControl.forEach((_processControl) => {
                    /**
                     * Create an element form group
                     */
                    lotControlFormGroups.push(
                      this._formBuilder.group({
                        id_process_control: _processControl.id_process_control,
                        official: [
                          {
                            value: _processControl.official,
                            disabled: false,
                          },
                          [Validators.required],
                        ],
                        process: [
                          {
                            value: _processControl.process,
                            disabled: false,
                          },
                          [Validators.required],
                        ],
                        task: [
                          {
                            value: _processControl.task,
                            disabled: false,
                          },
                          [Validators.required],
                        ],
                        level: [
                          {
                            value: _processControl.level,
                            disabled: false,
                          },
                          [Validators.required],
                        ],
                        control: [
                          {
                            value: _processControl.control,
                            disabled: false,
                          },
                          [Validators.required],
                        ],
                        value_process_control: [
                          {
                            value: _processControl.value_process_control,
                            disabled: true,
                          },
                          [Validators.required],
                        ],
                        last_change_process_control: [
                          {
                            value: _processControl.last_change_process_control,
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
                            _processControl.official.user.id_user,
                        ],
                      })
                    );
                  });
                  /**
                   * Add the element form groups to the element form array
                   */
                  lotControlFormGroups.forEach((_lotControlFormGroup: any) => {
                    (
                      this.taskRealizeForm.get('processControls') as FormArray
                    ).push(_lotControlFormGroup);
                  });
                });
            });
        }

        /**
         * Attached
         */
        if (this.template.plugin_attached_process) {
          /**
           * processAttached byLevelRead
           */
          this._processAttachedService
            .byLevelRead(this.task.level.id_level)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe();
          /**
           * Render plugin_attached_process
           */
          this._documentationProfileAttachedService
            .byDocumentationProfileRead(
              this.template.documentation_profile.id_documentation_profile
            )
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe(
              (
                _documentationProfileAttacheds: DocumentationProfileAttached[]
              ) => {
                this.documentationProfileAttacheds =
                  _documentationProfileAttacheds;

                /**
                 * Get the processAttacheds
                 */
                this._processAttachedService.processAttacheds$
                  .pipe(takeUntil(this._unsubscribeAll))
                  .subscribe((_processAttached: ProcessAttached[]) => {
                    this.processAttached = _processAttached;
                    /**
                     * Clear the lotAttached form arrays
                     */
                    (
                      this.taskRealizeForm.get('processAttacheds') as FormArray
                    ).clear();

                    const lotAttachedFormGroups: any = [];
                    /**
                     * Iterate through them
                     */
                    this.documentationProfileAttacheds.forEach(
                      (
                        _documentationProfileAttached: DocumentationProfileAttached,
                        index: number
                      ) => {
                        /**
                         * Add control for the input file
                         */
                        this.taskRealizeForm.addControl(
                          'removablefile' + index,
                          new FormControl(
                            {
                              value: '',
                              disabled: false,
                            },
                            [
                              FileValidator.maxContentSize(
                                _documentationProfileAttached.attached
                                  .length_mb_attached *
                                  1024 *
                                  1024
                              ),
                              _documentationProfileAttached.attached
                                .required_attached
                                ? Validators.required
                                : Validators.min(0),
                            ]
                          )
                        );
                        let _processAttached: ProcessAttached =
                          this.processAttached.find(
                            (_processAttached: ProcessAttached) =>
                              _processAttached.attached.id_attached ===
                              _documentationProfileAttached.attached.id_attached
                          )!;

                        let _matTooltip = ``;

                        if (_processAttached) {
                          /**
                           * Creamos un objeto file para ponerlo dentro del imput para que no lo puedan remplazar
                           */

                          const file = new File(
                            ['attached'],
                            this.getNameFile(_processAttached.server_path),
                            {
                              type: 'application/pdf',
                            }
                          );
                          this.taskRealizeForm
                            .get('removablefile' + index)
                            ?.patchValue(new FileInput([file]));

                          this.taskRealizeForm
                            .get('removablefile' + index)
                            ?.disable();
                          /**
                           * Set _matTooltip
                           */
                          _matTooltip = `${_processAttached.upload_date!} | ${
                            _processAttached.length_mb
                          }MB`;
                        } else {
                          _processAttached = this._processAttached;
                        }

                        /**
                         * Create a element form group
                         */
                        lotAttachedFormGroups.push(
                          this._formBuilder.group({
                            id_documentation_profile_attached:
                              _documentationProfileAttached.id_documentation_profile_attached,
                            id_attached:
                              _documentationProfileAttached.attached
                                .id_attached,
                            name_attached:
                              _documentationProfileAttached.attached
                                .name_attached,
                            description_attached:
                              _documentationProfileAttached.attached
                                .description_attached,
                            length_mb_attached:
                              _documentationProfileAttached.attached
                                .length_mb_attached,
                            required_attached:
                              _documentationProfileAttached.attached
                                .required_attached,
                            documentation_profile:
                              _documentationProfileAttached.documentation_profile,
                            matTooltip: _matTooltip,
                            /**
                             * Upload properties
                             */
                            isUpload:
                              _processAttached.id_process_attached != ' '
                                ? true
                                : false,
                            id_process_attached: _processAttached
                              ? _processAttached.id_process_attached
                              : '',
                            official: _processAttached
                              ? _processAttached.official
                              : '',
                            process: _processAttached
                              ? _processAttached.process
                              : '',
                            task: _processAttached ? _processAttached.task : '',
                            level: _processAttached
                              ? _processAttached.level
                              : '',
                            attached: _processAttached
                              ? _processAttached.attached
                              : '',
                            file_name: _processAttached
                              ? _processAttached.file_name
                              : '',
                            length_mb: _processAttached
                              ? _processAttached.length_mb
                              : '',
                            extension: _processAttached
                              ? _processAttached.extension
                              : '',
                            server_path: _processAttached
                              ? _processAttached.server_path
                              : '',
                            alfresco_path: _processAttached
                              ? _processAttached.alfresco_path
                              : '',
                            upload_date: _processAttached
                              ? _processAttached.upload_date
                              : '',
                            isOwner: [
                              this.data.user.id_user ==
                                _processAttached.official.user.id_user,
                            ],
                          })
                        );
                      }
                    );
                    /**
                     * Add the element form groups to the element form array
                     */
                    lotAttachedFormGroups.forEach(
                      (lotAttachedFormGroup: any) => {
                        (
                          this.taskRealizeForm.get(
                            'processAttacheds'
                          ) as FormArray
                        ).push(lotAttachedFormGroup);
                      }
                    );
                  });
              }
            );
        }

        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });

    /**
     * Components
     */
    // ------------------------------------------------------------------------
    /**
     * ProcessItem byLevelRead
     */
    this._processItemService
      .byLevelRead(this.task.level.id_level)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe();
    /**
     * Get the processItems
     */
    this._processItemService.processItems$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_processItem: ProcessItem[]) => {
        this.processItem = _processItem;
        if (this.processItem.length > 0) {
        }

        if (this.processItem.length == this.listItem.length) {
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
        this.listItem.map((item: Item, index: number) => {
          item = {
            ...item,
            isSelected: false,
          };
          this.listItem[index] = item;
        });

        let filterListItems: Item[] = cloneDeep(this.listItem);
        /**
         * Selected Items
         */
        this.processItem.map((itemOne: ProcessItem) => {
          /**
           * All Items
           */
          filterListItems.map((itemTwo: Item, index: number) => {
            if (itemTwo.id_item == itemOne.item!.id_item) {
              itemTwo = {
                ...itemTwo,
                isSelected: true,
              };

              filterListItems[index] = itemTwo;
            }
          });
        });

        this.listItem = filterListItems;
        /**
         * Filter select
         */
        /**
         * Clear the processItems form arrays
         */
        (this.taskRealizeForm.get('processItems') as FormArray).clear();

        const lotItemFormGroups: any = [];
        /**
         * Iterate through them
         */

        this.processItem.forEach((_processItem: ProcessItem, index: number) => {
          /**
           * Create an element form group
           */

          lotItemFormGroups.push(
            this._formBuilder.group({
              id_process_item: _processItem.id_process_item,
              official: [
                {
                  value: _processItem.official,
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
                  value: _processItem.item.id_item,
                  disabled:
                    this.processItem.length != index + 1 ||
                    this.isSelectedAllProcessItem,
                },
                [Validators.required],
              ],
              amount_process_item: [
                {
                  value: _processItem.amount_process_item,
                  disabled: false,
                },
                [Validators.required],
              ],
              features_process_item: [
                {
                  value: _processItem.features_process_item,
                  disabled: false,
                },
                [Validators.required],
              ],
              entry_date_process_item: [
                {
                  value: _processItem.entry_date_process_item,
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
                this.data.user.id_user == _processItem.official.user.id_user,
              ],
            })
          );
        });
        /**
         * Add the element form groups to the element form array
         */
        lotItemFormGroups.forEach((_lotItemFormGroup: any) => {
          (this.taskRealizeForm.get('processItems') as FormArray).push(
            _lotItemFormGroup
          );
        });
      });
    // ------------------------------------------------------------------------
  }

  get formArrayProcessItems(): FormArray {
    return this.taskRealizeForm.get('processItems') as FormArray;
  }

  get formArrayProcessControls(): FormArray {
    return this.taskRealizeForm.get('processControls') as FormArray;
  }

  get formArrayProcessAttacheds(): FormArray {
    return this.taskRealizeForm.get('processAttacheds') as FormArray;
  }

  getFromControl(
    formArray: FormArray,
    index: number,
    control: string
  ): FormControl {
    return formArray.controls[index].get(control) as FormControl;
  }
  /**
   * patchForm
   */
  patchForm(): void {
    this.taskRealizeForm.patchValue({
      ...this.template,
      id_documentation_profile:
        this.template.documentation_profile.id_documentation_profile,
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
  }
  /**
   * closeModalTaskRealize
   */
  closeModalTaskRealize(): void {
    this._modalTaskRealizeService.closeModalTaskRealize();
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
    const elementProcessItemFormArray = this.taskRealizeForm.get(
      'processItems'
    ) as FormArray;

    let processItem = elementProcessItemFormArray.getRawValue()[index];

    processItem = {
      ...processItem,
      id_user_: parseInt(id_user_),
      id_process_item: parseInt(processItem.id_process_item),
      official: {
        id_official: parseInt(processItem.official.id_official),
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
        id_item: parseInt(processItem.id_item),
      },
      amount_process_item: parseInt(processItem.amount_process_item),
      features_process_item: processItem.features_process_item.trim(),
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
  deleteProcessItem(index: number) {
    const elementProcessItemFormArray = this.taskRealizeForm.get(
      'processItems'
    ) as FormArray;

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
   * createProcessControl
   */
  createProcessControl() {
    const id_user_ = this.data.user.id_user;
    const id_official: string = this.task.official.id_official;
    const id_process: string = this.task.process.id_process;
    const id_task: string = this.task.id_task;
    const id_level: string = this.task.level.id_level;

    const id_control: string = '1';
    const value_process_control: string = '';

    this._processControlService
      .create(
        id_user_,
        id_official,
        id_process,
        id_task,
        id_level,
        id_control,
        value_process_control
      )
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_processControl: ProcessControl) => {
          if (_processControl) {
            const index = this.processControl.findIndex(
              (_processControl) =>
                _processControl.id_process_control ==
                _processControl.id_process_control
            );

            this._notificationService.success('Control agregado correctamente');
          } else {
            this._notificationService.error(
              'Ocurrió un error agregar el control'
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
   * updateProcessControl
   * @param index
   */
  updateProcessControl(index: number = 0) {
    const id_user_ = this.data.user.id_user;
    const elementProcessControlFormArray = this.taskRealizeForm.get(
      'processControls'
    ) as FormArray;

    let processControl = elementProcessControlFormArray.getRawValue()[index];

    processControl = {
      ...processControl,
      id_user_: parseInt(id_user_),
      id_process_control: parseInt(processControl.id_process_control),
      official: {
        id_official: parseInt(processControl.official.id_official),
      },
      process: {
        id_process: parseInt(processControl.process.id_process),
      },
      task: {
        id_task: parseInt(processControl.task.id_task),
      },
      level: {
        id_level: parseInt(processControl.level.id_level),
      },
      value_process_control: processControl.value_process_control.trim(),
    };

    this._processControlService
      .update(processControl)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_processControl: ProcessControl) => {
          if (_processControl) {
            this._notificationService.success('Control actualizado');
          } else {
            this._notificationService.error(
              'Ocurrió un error al actualiar el control'
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
   * deleteProcessControl
   * @param index
   */
  deleteProcessControl(index: number) {
    const elementProcessControlFormArray = this.taskRealizeForm.get(
      'processControls'
    ) as FormArray;

    const id_process_control =
      elementProcessControlFormArray.getRawValue()[index].id_process_control;
    const id_user_ = this.data.user.id_user;

    this._processControlService
      .delete(id_user_, id_process_control)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (response: boolean) => {
          if (response) {
            this._notificationService.success('Control eliminado');
          } else {
            this._notificationService.error(
              'Ocurrió un error eliminado el control'
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
   * createProcessAttached
   */
  createProcessAttached(target: any, index: number) {
    const id_user_ = this.data.user.id_user;
    const id_official: string = this.task.official.id_official;
    const id_process: string = this.task.process.id_process;
    const id_task: string = this.task.id_task;
    const id_level: string = this.task.level.id_level;

    const elementProcessAttachedFormArray = this.taskRealizeForm.get(
      'processAttacheds'
    ) as FormArray;

    const id_attached =
      elementProcessAttachedFormArray.getRawValue()[index].id_attached;

    const length_mb_attached =
      elementProcessAttachedFormArray.getRawValue()[index].length_mb_attached;

    const files: FileList = target.files;
    const file: File = files[0];

    const size: string = parseFloat(
      (file.size / 1024 / 1024).toFixed(2)
    ).toString();

    if (parseFloat(size) > length_mb_attached) {
      this._notificationService.warn(
        `El tamaño del archivo que está intentado subir supera al establecido por el perfil de documentación -> ${length_mb_attached} MB`
      );
      /**
       * Enabled FileInput
       */
      this.taskRealizeForm.get('removablefile' + index)?.enable();
    } else {
      const name: string = this.getInfoFile(file.name).name;
      const type: string = this.getInfoFile(file.name).extension;

      this._processAttachedService
        .create(
          id_user_,
          id_official,
          id_process,
          id_task,
          id_level,
          id_attached,
          name,
          size,
          type,
          file
        )
        .pipe(takeUntil(this._unsubscribeAll))
        .subscribe({
          next: (_processAttached: ProcessAttached) => {
            if (_processAttached) {
              this._notificationService.success('Anexo agregado correctamente');
            } else {
              this._notificationService.error(
                'Ocurrió un error agregar el anexo'
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
  }
  /**
   * downloadProcessAttached
   * @param index
   */
  downloadProcessAttached(index: number) {
    const elementProcessAttachedFormArray = this.taskRealizeForm.get(
      'processAttacheds'
    ) as FormArray;

    const server_path =
      elementProcessAttachedFormArray.getRawValue()[index].server_path;

    this._processAttachedService
      .downloadFile(server_path)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (dataSource: Blob) => {
          if (dataSource) {
            saveAs(dataSource, this.getNameFile(server_path));
          } else {
            this._notificationService.error(
              'Ocurrió un error descargando el archivo'
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
   * deleteProcessAttached
   * @param index
   */
  deleteProcessAttached(index: number) {
    const elementProcessAttachedFormArray = this.taskRealizeForm.get(
      'processAttacheds'
    ) as FormArray;

    const id_process_attached =
      elementProcessAttachedFormArray.getRawValue()[index].id_process_attached;
    const id_user_ = this.data.user.id_user;

    this._processAttachedService
      .delete(id_user_, id_process_attached)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (response: boolean) => {
          if (response) {
            this._notificationService.success('Anexo eliminado');
          } else {
            this._notificationService.error(
              'Ocurrió un error eliminado el anexo'
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
   * getInfoFile
   * @param nameFile
   * @returns object { name, extension }
   */
  getInfoFile = (nameFile: string) => {
    let position: number = 0;
    for (let index = 0; index < nameFile.length; index++) {
      const caracter: string = nameFile.substring(index, index + 1);
      if (caracter == '.') {
        position = index;
      }
    }
    return {
      name: nameFile.substring(0, position),
      extension: nameFile.substring(position, nameFile.length),
    };
  };
  /**
   * getNameFile
   * @param server_path
   * @returns
   */
  getNameFile = (server_path: string): string => {
    let position: number = 0;
    for (let index = 0; index < server_path.length; index++) {
      const caracter: string = server_path.substring(index, index + 1);
      if (caracter == '/') {
        position = index;
      }
    }
    return server_path.substring(position + 1, server_path.length);
  };
  /**
   * Track by function for ngFor loops
   * @param index
   * @param item
   */
  trackByFn(index: number, item: any): any {
    return item.id || index;
  }
}
