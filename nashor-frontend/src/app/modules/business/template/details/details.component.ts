import { angelAnimations } from '@angel/animations';
import { AngelAlertType } from '@angel/components/alert';
import {
  ActionAngelConfirmation,
  AngelConfirmationService,
} from '@angel/services/confirmation';
import { CdkDragDrop, moveItemInArray } from '@angular/cdk/drag-drop';
import { OverlayRef } from '@angular/cdk/overlay';
import { CdkTextareaAutosize } from '@angular/cdk/text-field';
import { ChangeDetectorRef, Component, OnInit, ViewChild } from '@angular/core';
import {
  FormArray,
  FormBuilder,
  FormControl,
  FormGroup,
  Validators,
} from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { Store } from '@ngrx/store';
import { AppInitialData, MessageAPI } from 'app/core/app/app.type';
import { LayoutService } from 'app/layout/layout.service';
import { company } from 'app/modules/core/company/company.data';
import { NotificationService } from 'app/shared/notification/notification.service';
import { Subject, takeUntil } from 'rxjs';
import { Attached } from '../../attached/attached.types';
import { DocumentationProfileAttachedService } from '../../documentation-profile/documentation-profile-attached/documentation-profile-attached.service';
import { DocumentationProfileAttached } from '../../documentation-profile/documentation-profile-attached/documentation-profile-attached.types';
import { ItemService } from '../../item/item.service';
import { Item } from '../../item/item.types';
import { ModalExistingControlService } from '../modal-existing-control/modal-existing-control.service';
import { ModalTemplateService } from '../modal-template/modal-template.service';
import { TemplateControlService } from '../template-control/template-control.service';
import { TemplateControl } from '../template-control/template-control.types';
import { TemplateService } from '../template.service';
import { Template } from '../template.types';

@Component({
  selector: 'template-details',
  templateUrl: './details.component.html',
  styleUrls: ['./details.component.scss'],
  animations: angelAnimations,
})
export class TemplateDetailsComponent implements OnInit {
  @ViewChild('autosize') autosize!: CdkTextareaAutosize;
  form!: FormGroup;

  atacheds: Attached[] = [
    {
      id_attached: '1',
      company: company,
      name_attached: 'Cedula',
      description_attached: 'Sube tu copia de la cedula',
      length_mb_attached: 2,
      required_attached: true,
      deleted_attached: false,
    },
    {
      id_attached: '1',
      company: company,
      name_attached: 'Papeleta de votación',
      description_attached: 'Sube tu copia de la papeleta de votación',
      length_mb_attached: 2,
      required_attached: true,
      deleted_attached: false,
    },
    {
      id_attached: '1',
      company: company,
      name_attached: 'Carnet de vacunación',
      description_attached: '',
      length_mb_attached: 50,
      required_attached: true,
      deleted_attached: false,
    },
  ];

  categoriesItem: Item[] = [];

  // Private
  private data!: AppInitialData;

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
  template!: Template;
  templateForm!: FormGroup;

  private _tagsPanelOverlayRef!: OverlayRef;
  private _unsubscribeAll: Subject<any> = new Subject<any>();
  /**
   * isOpenModal
   */
  isOpenModal: boolean = false;
  /**
   * isOpenModal
   */
  templateControl!: TemplateControl[];
  /**
   * Constructor
   */
  constructor(
    private _store: Store<{ global: AppInitialData }>,
    private _changeDetectorRef: ChangeDetectorRef,
    private _activatedRoute: ActivatedRoute,
    private _templateService: TemplateService,
    private _formBuilder: FormBuilder,
    private _router: Router,
    private _layoutService: LayoutService,
    private _modalTemplateService: ModalTemplateService,
    private _modalExistingControlService: ModalExistingControlService,
    private _angelConfirmationService: AngelConfirmationService,
    private _notificationService: NotificationService,
    private _templateControlService: TemplateControlService,
    private _itemService: ItemService,
    private _documentationProfileAttachedService: DocumentationProfileAttachedService
  ) {}

  /** ----------------------------------------------------------------------------------------------------- */
  /** @ Lifecycle hooks
	  /** ----------------------------------------------------------------------------------------------------- */
  /**
   * On init
   */
  ngOnInit(): void {
    /**
     * readAllItem
     */
    this._itemService
      .queryRead('*')
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((items: Item[]) => {
        this.categoriesItem = items;
      });

    this.form = this._formBuilder.group({});
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
    });
    /**
     * Create the template form
     */
    this.templateForm = this._formBuilder.group({
      id_template: [''],
      company: ['', [Validators.required]],
      id_documentation_profile: ['', [Validators.required]],
      plugin_item_process: ['', [Validators.required]],
      plugin_attached_process: ['', [Validators.required]],
      name_template: ['', [Validators.required, Validators.maxLength(100)]],
      description_template: [
        '',
        [Validators.required, Validators.maxLength(250)],
      ],
      status_template: ['', [Validators.required]],
      last_change: [''],
      in_use: [''],
      lotAttached: this._formBuilder.array([]),
    });
    /**
     * Get the template
     */
    this._templateService.template$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((template: Template) => {
        /**
         * Get the template
         */
        this.template = template;
        /**
         * Subscribe byTemplateRead
         */
        this._templateControlService
          .byTemplateRead(this.template.id_template)
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe();
        /**
         * Subscribe templateControls$
         */
        this._templateControlService.templateControls$
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((_templateControl: TemplateControl[]) => {
            this.templateControl = _templateControl;
            console.log(_templateControl);
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
                this.form.addControl(
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
              } else if (_templateControl.control.type_control === 'checkBox') {
                _templateControl.control.options_control.map((item: any) => {
                  this.form.addControl(
                    `${_templateControl.control.form_name_control}${item.value}`,
                    new FormControl(null)
                  );
                });
              } else if (
                _templateControl.control.type_control === 'dateRange'
              ) {
                this.form.addControl(
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
                this.form.addControl(
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
          });
        /**
         * Render plugin_attached_process
         */
        if (this.template.plugin_attached_process) {
          this._documentationProfileAttachedService
            .byDocumentationProfileRead(
              this.template.documentation_profile.id_documentation_profile
            )
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe(
              (
                _documentationProfileAttacheds: DocumentationProfileAttached[]
              ) => {
                /**
                 * Clear the lotAttached form arrays
                 */
                (this.templateForm.get('lotAttached') as FormArray).clear();

                const lotAttachedFormGroups: any = [];
                /**
                 * Iterate through them
                 */
                _documentationProfileAttacheds.forEach(
                  (_documentationProfileAttached: any, index: number) => {
                    /**
                     * Add control for the input file
                     */
                    this.form.addControl(
                      'removablefile' + index,
                      new FormControl({
                        value: '',
                        disabled: false,
                      })
                    );
                    /**
                     * Create a element form group
                     */
                    lotAttachedFormGroups.push(
                      this._formBuilder.group({
                        id_documentation_profile_attached:
                          _documentationProfileAttached.id_documentation_profile_attached,
                        id_attached:
                          _documentationProfileAttached.attached.id_attached,
                        name_attached:
                          _documentationProfileAttached.attached.name_attached,
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
                      })
                    );
                  }
                );
                /**
                 * Add the elemento form groups to the elemento form array
                 */
                lotAttachedFormGroups.forEach((lotAttachedFormGroup: any) => {
                  (this.templateForm.get('lotAttached') as FormArray).push(
                    lotAttachedFormGroup
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
  }

  get formArrayAttached(): FormArray {
    return this.templateForm.get('lotAttached') as FormArray;
  }

  getFromControl(
    formArray: FormArray,
    index: number,
    control: string
  ): FormControl {
    return formArray.controls[index].get(control) as FormControl;
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
   * Go to Control
   * @param id
   */
  goToEntity(id: string): void {
    /**
     * Get the current activated route
     */
    let route = this._activatedRoute;
    while (route.firstChild) {
      route = route.firstChild;
    }
    /**
     * Go to Control
     */
    this._router.navigate(['template-control', id], {
      relativeTo: route,
    });
    /**
     * Mark for check
     */
    this._changeDetectorRef.markForCheck();
  }
  /**
   * openModalTemplate
   */
  openModalTemplate(id_template: string) {
    this._modalTemplateService.openModalTemplate(id_template);
  }
  /**
   *  addNewControl
   */
  addNewControl() {
    this._angelConfirmationService
      .open({
        title: 'Añadir control',
        message:
          '¿Estás seguro de que deseas añadir una nueva control? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          const id_user_ = this.data.user.id_user;
          const id_template = this.template.id_template;
          /**
           * Create the control
           */
          this._templateControlService
            .createWithNewControl(id_user_, id_template)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (_templateControl: TemplateControl) => {
                if (_templateControl) {
                  this._notificationService.success(
                    'Control agregado correctamente'
                  );
                  /**
                   * Go to new control
                   */
                  this.goToEntity(_templateControl.id_template_control);
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
  // /**
  //  * addExistingControl
  //  */
  // addExistingControl() {
  //   this._modalExistingControlService.openExistingControl(
  //     this.data.user.id_user,
  //     this.template.id_template
  //   );
  // }
  /**
   * Card dropped
   *
   * @param event
   */
  controlDropped(event: CdkDragDrop<TemplateControl[]>): void {
    const id_user = this.data.user.id_user;
    // Move the item
    moveItemInArray(
      event.container.data,
      event.previousIndex,
      event.currentIndex
    );

    this._templateControlService
      .updatePositions(id_user, this.template.id_template, event.container.data)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_templateControls: TemplateControl[]) => {
          if (!_templateControls) {
            this._notificationService.error(
              'Ocurrió un error actualizando la posición'
            );
            this._notificationService.success('Posiciones actualizadas');
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
   * deleteTemplateControl
   */
  deleteTemplateControl(id_template_control: string): void {
    this._angelConfirmationService
      .open({
        title: 'Eliminar control',
        message:
          '¿Estás seguro de que deseas eliminar este control? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          const id_user = this.data.user.id_user;

          this._templateControlService
            .delete(id_user, id_template_control)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (response: boolean) => {
                if (response) {
                  this._notificationService.success(
                    'Control eliminado correctamente'
                  );
                } else {
                  this._notificationService.error(
                    'Ocurrió un error eliminando el control'
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
          /**
           * Mark for check
           */
          this._changeDetectorRef.markForCheck();
        }
        this._layoutService.setOpenModal(false);
      });
  }
  /**
   * Track by function for ngFor loops
   *
   * @param index
   * @param item
   */
  trackByFn(index: number, item: any): any {
    return item.id || index;
  }
}
