import { angelAnimations } from '@angel/animations';
import { AngelAlertType } from '@angel/components/alert';
import {
  ActionAngelConfirmation,
  AngelConfirmationService,
} from '@angel/services/confirmation';
import { OverlayRef } from '@angular/cdk/overlay';
import { DOCUMENT } from '@angular/common';
import { ChangeDetectorRef, Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDrawerToggleResult } from '@angular/material/sidenav';
import { ActivatedRoute, Router } from '@angular/router';
import { Store } from '@ngrx/store';
import Ajv from 'ajv';
import { AppInitialData, MessageAPI } from 'app/core/app/app.type';
import { LayoutService } from 'app/layout/layout.service';
import { ModalViewSchemaService } from 'app/shared/modal-view-schema/modal-view-schema.service';
import { NotificationService } from 'app/shared/notification/notification.service';
import { UsernameValidator } from 'app/shared/username.validator';
import { filter, fromEvent, merge, Subject, takeUntil } from 'rxjs';
import { ControlService } from '../control.service';
import {
  Control,
  TYPE_CONTROL,
  TYPE_CONTROL_ENUM,
  _typeControl,
} from '../control.types';
import { ControlListComponent } from '../list/list.component';
import schemaFile from '../schema.options.control.json';

@Component({
  selector: 'control-details',
  templateUrl: './details.component.html',
  animations: angelAnimations,
})
export class ControlDetailsComponent implements OnInit {
  nameEntity: string = 'Control';
  private data!: AppInitialData;

  /**
   * ajv
   */
  ajv = new Ajv({ allErrors: true });
  schema = schemaFile;
  /**
   * ajv
   */
  /**
   * Type Enum TYPE_CONTROL
   */
  typeControl: TYPE_CONTROL_ENUM[] = _typeControl;

  typeControlSelect!: TYPE_CONTROL_ENUM;

  /**
   * Type Enum TYPE_CONTROL
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
  control!: Control;
  controlForm!: FormGroup;
  private controls!: Control[];

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
    private _controlListComponent: ControlListComponent,
    private _controlService: ControlService,
    @Inject(DOCUMENT) private _document: any,
    private _formBuilder: FormBuilder,
    private _activatedRoute: ActivatedRoute,
    private _router: Router,
    private _notificationService: NotificationService,
    private _angelConfirmationService: AngelConfirmationService,
    private _layoutService: LayoutService,
    private _modalViewSchemaService: ModalViewSchemaService
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
    });
    /**
     * Open the drawer
     */
    this._controlListComponent.matDrawer.open();
    /**
     * Create the control form
     */
    this.controlForm = this._formBuilder.group({
      id_control: [''],
      company: [''],
      type_control: ['', [Validators.required]],
      title_control: ['', [Validators.required, Validators.maxLength(50)]],
      form_name_control: [
        '',
        [
          Validators.required,
          Validators.maxLength(50),
          UsernameValidator.cannotContainSpace,
        ],
      ],
      initial_value_control: [
        '',
        [Validators.required, Validators.maxLength(100)],
      ],
      required_control: ['', [Validators.required]],
      min_length_control: ['', [Validators.maxLength(3)]],
      max_length_control: ['', [Validators.maxLength(3)]],
      placeholder_control: ['', [Validators.maxLength(100)]],
      spell_check_control: [''],
      options_control: [''],
      in_use: [''],
    });
    /**
     * Get the controls
     */
    this._controlService.controls$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((controls: Control[]) => {
        this.controls = controls;
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
    /**
     * Get the control
     */
    this._controlService.control$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((control: Control) => {
        /**
         * Open the drawer in case it is closed
         */
        this._controlListComponent.matDrawer.open();
        /**
         * Get the control
         */
        this.control = control;
        /**
         * Set required to controls what do you require
         */
        if (
          this.control.type_control === 'radioButton' ||
          this.control.type_control === 'checkBox' ||
          this.control.type_control === 'select'
        ) {
          this.controlForm.controls['options_control'].setValidators([
            Validators.required,
          ]);
        }

        /**
         * Type Enum TYPE_CONTROL
         */
        this.typeControlSelect = this.typeControl.find(
          (e_control) => e_control.value_type == this.control.type_control
        )!;
        /**
         * Type Enum TYPE_CONTROL
         */
        /**
         * Patch values to the form
         */
        this.patchForm();
        /**
         * Toggle the edit mode off
         */
        this.toggleEditMode(false);
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
    /**
     * Shortcuts
     */
    merge(
      fromEvent(this._document, 'keydown').pipe(
        takeUntil(this._unsubscribeAll),
        filter<KeyboardEvent | any>((e) => e.key === 'Escape')
      )
    )
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((keyUpOrKeyDown) => {
        console.log(keyUpOrKeyDown);
        /**
         * Shortcut Escape
         */
        if (!this.isOpenModal && keyUpOrKeyDown.key == 'Escape') {
          /**
           * Navigate parentUrl
           */
          const parentUrl = this._router.url.split('/').slice(0, -1).join('/');
          this._router.navigate([parentUrl]);
          /**
           * Close Drawer
           */
          this.closeDrawer();
        }
      });
    /**
     * Shortcuts
     */
  }
  /**
   * Pacth the form with the information of the database
   */
  patchForm(): void {
    this.controlForm.patchValue({
      ...this.control,
      id_company: this.control.company.id_company,
      options_control: this.parseJsonToText(this.control.options_control),
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
   * Close the drawer
   */
  closeDrawer(): Promise<MatDrawerToggleResult> {
    return this._controlListComponent.matDrawer.close();
  }
  /**
   * Toggle edit mode
   * @param editMode
   */
  toggleEditMode(editMode: boolean | null = null): void {
    this.patchForm();

    if (editMode === null) {
      this.editMode = !this.editMode;
    } else {
      this.editMode = editMode;
    }
    /**
     * Mark for check
     */
    this._changeDetectorRef.markForCheck();
  }

  /**
   * Update the control
   */
  updateControl(): void {
    /**
     * Get the control
     */
    const id_user_ = this.data.user.id_user;
    let control = this.controlForm.getRawValue();
    /**
     * Delete whitespace (trim() the atributes type string)
     */
    control = {
      ...control,
      id_user_: parseInt(id_user_),
      id_control: parseInt(control.id_control),
      min_length_control: parseInt(control.min_length_control),
      max_length_control: parseInt(control.max_length_control),
      company: {
        id_company: parseInt(control.company.id_company),
      },
      options_control:
        control.options_control == ''
          ? {}
          : JSON.parse(control.options_control),
    };
    /**
     * Update
     */
    this._controlService
      .update(control)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_control: Control) => {
          console.log(_control);
          if (_control) {
            this._notificationService.success(
              'Control actualizada correctamente'
            );
            /**
             * Toggle the edit mode off
             */
            this.toggleEditMode(false);
          } else {
            this._notificationService.error(
              '¡Error interno!, consulte al administrador.'
            );
          }
        },
        error: (error: { error: MessageAPI }) => {
          console.log(error);
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
   * Delete the control
   */
  deleteControl(): void {
    this._angelConfirmationService
      .open({
        title: 'Eliminar control',
        message:
          '¿Estás seguro de que deseas eliminar esta control? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          /**
           * Get the current control's id
           */
          const id_user_ = this.data.user.id_user;
          const id_control = this.control.id_control;
          /**
           * Get the next/previous control's id
           */
          const currentIndex = this.controls.findIndex(
            (item) => item.id_control === id_control
          );

          const nextIndex =
            currentIndex + (currentIndex === this.controls.length - 1 ? -1 : 1);
          const nextId =
            this.controls.length === 1 &&
            this.controls[0].id_control === id_control
              ? null
              : this.controls[nextIndex].id_control;
          /**
           * Delete
           */
          this._controlService
            .delete(id_user_, id_control)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (response: boolean) => {
                console.log(response);
                if (response) {
                  /**
                   * Return if the control wasn't deleted...
                   */
                  this._notificationService.success(
                    'Control eliminada correctamente'
                  );
                  /**
                   * Get the current activated route
                   */
                  let route = this._activatedRoute;
                  while (route.firstChild) {
                    route = route.firstChild;
                  }
                  /**
                   * Navigate to the next control if available
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
                  /**
                   * Toggle the edit mode off
                   */
                  this.toggleEditMode(false);
                } else {
                  this._notificationService.error(
                    '¡Error interno!, consulte al administrador.'
                  );
                }
              },
              error: (error: { error: MessageAPI }) => {
                console.log(error);
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
   * getTypeControlEnum
   */
  getTypeControlEnum(type_control: TYPE_CONTROL): TYPE_CONTROL_ENUM {
    return this.typeControl.find(
      (e_control) => e_control.value_type == type_control
    )!;
  }
  /**
   * parseJsonToText
   * @returns
   */
  parseJsonToText(json: any) {
    return JSON.stringify(json, null, 2);
  }
  /**
   * IsJsonString
   * @returns
   */
  IsJsonString(str: string) {
    try {
      JSON.parse(str);
    } catch (e) {
      return false;
    }
    return true;
  }
  /**
   * validateJsonScheme
   * @returns
   */
  validateJsonScheme(schema: any, data: any): boolean {
    const validate = this.ajv.compile(schema);
    const isValid = validate(data);
    return isValid;
  }
  /**
   * viewSchema
   */
  viewSchema() {
    this._modalViewSchemaService
      .openModalViewSchemaService(this.schema)
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe(() => {
        this._layoutService.setOpenModal(false);
      });
  }
}
