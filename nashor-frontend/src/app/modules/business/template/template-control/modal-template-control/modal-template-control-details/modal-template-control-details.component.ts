import { angelAnimations } from '@angel/animations';
import { AngelAlertType } from '@angel/components/alert';
import {
  ActionAngelConfirmation,
  AngelConfirmationService,
} from '@angel/services/confirmation';
import { OverlayRef } from '@angular/cdk/overlay';
import { CdkTextareaAutosize } from '@angular/cdk/text-field';
import { ChangeDetectorRef, Component, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDialog } from '@angular/material/dialog';
import { Store } from '@ngrx/store';
import Ajv from 'ajv';
import { AppInitialData, MessageAPI } from 'app/core/app/app.type';
import { LayoutService } from 'app/layout/layout.service';
import { ControlService } from 'app/modules/business/control/control.service';
import {
  Control,
  TYPE_CONTROL_ENUM,
  _typeControl,
} from 'app/modules/business/control/control.types';
import { ModalViewSchemaService } from 'app/shared/modal-view-schema/modal-view-schema.service';
import { NotificationService } from 'app/shared/notification/notification.service';
import { UsernameValidator } from 'app/shared/username.validator';
import { Subject, takeUntil } from 'rxjs';
import schemaFile from '../../../../control/schema.options.control.json';
import { TemplateControlService } from '../../template-control.service';
import { TemplateControl } from '../../template-control.types';

@Component({
  selector: 'app-modal-template-control-details',
  templateUrl: './modal-template-control-details.component.html',
  animations: angelAnimations,
})
export class ModalTemplateControlDetailsComponent implements OnInit {
  @ViewChild('autosize') autosize!: CdkTextareaAutosize;
  /**
   * ajv
   */
  ajv = new Ajv({ allErrors: true });
  schema = schemaFile;
  /**
   * ajv
   */
  nameEntity: string = 'Control';
  private data!: AppInitialData;

  /**
   * Type Enum
   */
  typeControl: TYPE_CONTROL_ENUM[] = _typeControl;

  typeSelect!: TYPE_CONTROL_ENUM;
  /**
   * Type Enum
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
  templateControl!: TemplateControl;
  templateControlForm!: FormGroup;

  private _tagsPanelOverlayRef!: OverlayRef;
  private _unsubscribeAll: Subject<any> = new Subject<any>();

  /**
   * Constructor
   */
  constructor(
    private _store: Store<{ global: AppInitialData }>,
    private _changeDetectorRef: ChangeDetectorRef,
    private _templateControlService: TemplateControlService,
    private _controlService: ControlService,
    private _matDialog: MatDialog,
    private _formBuilder: FormBuilder,
    private _notificationService: NotificationService,
    private _angelConfirmationService: AngelConfirmationService,
    private _layoutService: LayoutService,
    private _modalViewSchemeService: ModalViewSchemaService
  ) {}

  /** ----------------------------------------------------------------------------------------------------- */
  /** @ Lifecycle hooks
	/** ----------------------------------------------------------------------------------------------------- */

  /**
   * On init
   */
  ngOnInit(): void {
    /**
     * Subscribe to user changes of state
     */
    this._store.pipe(takeUntil(this._unsubscribeAll)).subscribe((state) => {
      this.data = state.global;
    });
    /**
     * Create the control form
     */
    this.templateControlForm = this._formBuilder.group({
      id_template_control: [''],
      template: [''],
      id_control: [''],
      ordinal_position: [''],
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
      initial_value_control: ['', [Validators.maxLength(100)]],
      required_control: ['', [Validators.required]],
      min_length_control: ['', [Validators.maxLength(3)]],
      max_length_control: ['', [Validators.maxLength(3)]],
      placeholder_control: ['', [Validators.maxLength(100)]],
      spell_check_control: [''],
      options_control: [''],
      in_use: [''],
    });
    /**
     * Get the control
     */
    this._templateControlService.templateControl$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_templateControl: TemplateControl) => {
        /**
         * Get the control
         */
        this.templateControl = _templateControl;

        /**
         * Type Enum
         */
        this.typeSelect = this.typeControl.find(
          (control) =>
            control.value_type == this.templateControl.control.type_control
        )!;

        /**
         * Set required to controls what do you require
         */
        if (
          this.templateControl.control.type_control === 'radioButton' ||
          this.templateControl.control.type_control === 'checkBox' ||
          this.templateControl.control.type_control === 'select'
        ) {
          this.templateControlForm.controls['options_control'].setValidators([
            Validators.required,
          ]);
        }
        /**
         * Type Enum
         */
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
    this.templateControlForm.patchValue({
      ...this.templateControl,
      id_control: this.templateControl.control.id_control,
      company: this.templateControl.control.company,
      type_control: this.templateControl.control.type_control,
      title_control: this.templateControl.control.title_control,
      form_name_control: this.templateControl.control.form_name_control,
      initial_value_control: this.templateControl.control.initial_value_control,
      required_control: this.templateControl.control.required_control,
      min_length_control: this.templateControl.control.min_length_control,
      max_length_control: this.templateControl.control.max_length_control,
      placeholder_control: this.templateControl.control.placeholder_control,
      spell_check_control: this.templateControl.control.spell_check_control,
      options_control: this.parseJsonToText(
        this.templateControl.control.options_control
      ),
      in_use: this.templateControl.control.in_use,
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
   * Update the control
   */
  updateControl(): void {
    /**
     * Get the control
     */
    const id_user_ = this.data.user.id_user;
    let templateControl = this.templateControlForm.getRawValue();
    /**
     * Delete whitespace (trim() the atributes type string)
     */
    templateControl = {
      id_user_: parseInt(id_user_),
      id_template_control: templateControl.id_template_control,
      template: templateControl.template,
      control: {
        id_control: parseInt(templateControl.id_control),
        company: {
          id_company: parseInt(templateControl.company.id_company),
        },
        type_control: templateControl.type_control,
        title_control: templateControl.title_control,
        form_name_control: templateControl.form_name_control,
        initial_value_control: templateControl.initial_value_control,
        required_control: templateControl.required_control,
        min_length_control: parseInt(templateControl.min_length_control),
        max_length_control: parseInt(templateControl.max_length_control),
        placeholder_control: templateControl.placeholder_control,
        spell_check_control: templateControl.spell_check_control,
        options_control: templateControl.options_control,
        in_use: templateControl.in_use,
      },
      ordinal_position: parseInt(templateControl.ordinal_position),
    };

    /**
     * Validation if type_control haved options
     */
    if (
      templateControl.control.type_control === 'radioButton' ||
      templateControl.control.type_control === 'checkBox' ||
      templateControl.control.type_control === 'select'
    ) {
      if (!this.IsJsonString(templateControl.control.options_control)) {
        this._notificationService.error(
          '¡El esquema JSON del contenido es invalido!'
        );
        return;
      }
      if (
        !this.validateJsonScheme(
          this.schema,
          JSON.parse(templateControl.control.options_control)
        )
      ) {
        this._notificationService.error(
          '¡El contenido de la navegación no concuerda con el esquema!'
        );
        return;
      }
    }
    /**
     * Update
     */
    this._templateControlService
      .updateTemplateControlProperties({
        ...templateControl,
        control: {
          ...templateControl.control,
          options_control: JSON.parse(templateControl.control.options_control),
        },
      })
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_control: Control) => {
          if (_control) {
            this._notificationService.success(
              'Control actualizado correctamente'
            );
            this.closeModalControl();
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
          const id_control = this.templateControlForm.getRawValue().id_control;
          /**
           * Delete the control
           */
          this._controlService
            .cascadeDelete(id_user_, id_control)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (response: boolean) => {
                if (response) {
                  /**
                   * Return if the control wasn't deleted...
                   */
                  this._notificationService.success(
                    'Control eliminada correctamente'
                  );
                  this.closeModalControl();
                  this._templateControlService
                    .delete(id_user_, id_control)
                    .pipe(takeUntil(this._unsubscribeAll))
                    .subscribe();
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
    this._modalViewSchemeService
      .openModalViewSchemaService(this.schema)
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe(() => {
        this._layoutService.setOpenModal(false);
      });
  }
  /**
   * closeModalControl
   */
  closeModalControl(): void {
    this._matDialog.closeAll();
  }
}
