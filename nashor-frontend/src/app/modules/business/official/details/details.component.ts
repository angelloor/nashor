import { angelAnimations } from '@angel/animations';
import { AngelAlertType } from '@angel/components/alert';
import {
    ActionAngelConfirmation,
    AngelConfirmationService
} from '@angel/services/confirmation';
import { OverlayRef } from '@angular/cdk/overlay';
import { DOCUMENT } from '@angular/common';
import {
    ChangeDetectorRef,
    Component,
    ElementRef,
    Inject,
    OnInit,
    ViewChild
} from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDrawerToggleResult } from '@angular/material/sidenav';
import { ActivatedRoute, Router } from '@angular/router';
import { Store } from '@ngrx/store';
import { AppInitialData, MessageAPI } from 'app/core/app/app.type';
import { LayoutService } from 'app/layout/layout.service';
import { company } from 'app/modules/core/company/company.data';
import { CompanyService } from 'app/modules/core/company/company.service';
import { Company } from 'app/modules/core/company/company.types';
import { TYPE_PROFILE } from 'app/modules/core/profile/profile.types';
import { SessionService } from 'app/modules/core/session/session.service';
import { typeUser } from 'app/modules/core/type-user/type-user.data';
import { TypeUserService } from 'app/modules/core/type-user/type-user.service';
import { TypeUser } from 'app/modules/core/type-user/type-user.types';
import { user } from 'app/modules/core/user/user.data';
import { UserService } from 'app/modules/core/user/user.service';
import { User } from 'app/modules/core/user/user.types';
import { validation } from 'app/modules/core/validation/validation.data';
import { ValidationService } from 'app/modules/core/validation/validation.service';
import { Validation } from 'app/modules/core/validation/validation.types';
import { NotificationService } from 'app/shared/notification/notification.service';
import { SecurityCap } from 'app/utils/SecurityCap';
import { environment } from 'environments/environment';
import { filter, fromEvent, merge, Subject, takeUntil } from 'rxjs';
import { area } from '../../area/area.data';
import { AreaService } from '../../area/area.service';
import { Area } from '../../area/area.types';
import { position } from '../../position/position.data';
import { PositionService } from '../../position/position.service';
import { Position } from '../../position/position.types';
import { OfficialListComponent } from '../list/list.component';
import { OfficialService } from '../official.service';
import { Official } from '../official.types';

@Component({
  selector: 'official-details',
  templateUrl: './details.component.html',
  animations: angelAnimations,
})
export class OfficialDetailsComponent implements OnInit {
  _urlPathAvatar: string = environment.urlBackend + '/resource/img/avatar/';
  type_profile: TYPE_PROFILE = 'commonProfile';
  id_company: string = '';

  @ViewChild('avatarFileInput') private _avatarFileInput!: ElementRef;

  listUser: User[] = [];
  selectedUser: User = user;

  listArea: Area[] = [];
  selectedArea: Area = area;

  listPosition: Position[] = [];
  selectedPosition: Position = position;

  listCompany: Company[] = [];
  selectedCompany: Company = company;

  listTypeUser: TypeUser[] = [];
  selectedTypeUser: TypeUser = typeUser;

  nameEntity: string = 'Funcionario';
  private data!: AppInitialData;

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
  official!: Official;
  officialForm!: FormGroup;
  private officials!: Official[];

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
   * Validation
   */
  validationPassword: Validation = validation;
  validationDNI: Validation = validation;
  validationPhoneNumber: Validation = validation;
  /**
   * Validation
   */
  /**
   * Constructor
   */
  constructor(
    private _store: Store<{ global: AppInitialData }>,
    private _changeDetectorRef: ChangeDetectorRef,
    private _officialListComponent: OfficialListComponent,
    private _officialService: OfficialService,
    @Inject(DOCUMENT) private _document: any,
    private _formBuilder: FormBuilder,
    private _securityCap: SecurityCap,
    private _activatedRoute: ActivatedRoute,
    private _router: Router,
    private _notificationService: NotificationService,
    private _angelConfirmationService: AngelConfirmationService,
    private _layoutService: LayoutService,
    private _userService: UserService,
    private _typeUserService: TypeUserService,
    private _companyService: CompanyService,
    private _areaService: AreaService,
    private _positionService: PositionService,
    private _validationService: ValidationService,
    private _sessionService: SessionService
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
      this.type_profile = this.data.user.type_user.profile.type_profile;
    });
    /**
     * Open the drawer
     */
    this._officialListComponent.matDrawer.open();
    /**
     * Create the official form
     */
    this.officialForm = this._formBuilder.group({
      id_official: [''],
      id_company: [''],
      id_user: [''],
      name_user: ['', [Validators.required, Validators.maxLength(320)]],
      password_user: ['', [Validators.required, Validators.maxLength(250)]],
      avatar_user: ['', [Validators.required, Validators.maxLength(50)]],
      status_user: ['', [Validators.required]],

      id_person: [''],
      dni_person: ['', [Validators.required, Validators.maxLength(20)]],
      name_person: ['', [Validators.required, Validators.maxLength(150)]],
      last_name_person: ['', [Validators.required, Validators.maxLength(150)]],
      address_person: ['', [Validators.required, Validators.maxLength(150)]],
      phone_person: ['', [Validators.required, Validators.maxLength(13)]],

      id_academic: [''],
      title_academic: ['', [Validators.maxLength(250)]],
      abbreviation_academic: ['', [Validators.maxLength(50)]],
      level_academic: ['', [Validators.maxLength(100)]],

      id_job: [''],
      name_job: ['', [Validators.maxLength(200)]],
      address_job: ['', [Validators.maxLength(200)]],
      phone_job: ['', [Validators.maxLength(13)]],
      position_job: ['', [Validators.maxLength(150)]],

      id_type_user: ['', [Validators.required]],

      id_area: ['', [Validators.required]],
      id_position: ['', [Validators.required]],
    });
    /**
     * Validations
     */
    this._validationService.validationsActive$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((validations: Validation[]) => {
        /**
         * validationPassword
         */
        if (
          !validations.find(
            (validation) => validation.type_validation == 'validationPassword'
          )
        ) {
          this._validationService
            .byTypeValidationQueryRead(this.id_company, 'validationPassword')
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
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
          this.validationPassword = validations.find(
            (validation) =>
              validation.type_validation == 'validationPassword' &&
              validation.status_validation
          )!;
          /**
           * Set Validation Pattern
           */
          if (this.validationPassword) {
            /**
             * Parse to String RegExp to RegExp
             */
            let validationPasswordRegExp = new RegExp(
              this.validationPassword.pattern_validation
            );
            /**
             * Set Validators
             */
            this.officialForm.controls['password_user'].setValidators([
              Validators.required,
              Validators.maxLength(250),
              Validators.pattern(validationPasswordRegExp),
            ]);
          } else {
            this.officialForm.controls['password_user'].setValidators([
              Validators.required,
              Validators.maxLength(250),
            ]);
          }
        }
        /**
         * validationDNI
         */
        if (
          !validations.find(
            (validation) => validation.type_validation == 'validationDNI'
          )
        ) {
          this._validationService
            .byTypeValidationQueryRead(this.id_company, 'validationDNI')
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
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
          this.validationDNI = validations.find(
            (validation) =>
              validation.type_validation == 'validationDNI' &&
              validation.status_validation
          )!;
          /**
           * Set Validation Pattern
           */
          if (this.validationDNI) {
            /**
             * Parse to String RegExp to RegExp
             */
            let validationDNIRegExp = new RegExp(
              this.validationDNI.pattern_validation
            );
            /**
             * Set Validators
             */
            this.officialForm.controls['dni_person'].setValidators([
              Validators.required,
              Validators.maxLength(20),
              Validators.pattern(validationDNIRegExp),
            ]);
          } else {
            this.officialForm.controls['dni_person'].setValidators([
              Validators.required,
              Validators.maxLength(20),
            ]);
          }
        }
        /**
         * validationPhoneNumber
         */
        if (
          !validations.find(
            (validation) =>
              validation.type_validation == 'validationPhoneNumber'
          )
        ) {
          this._validationService
            .byTypeValidationQueryRead(this.id_company, 'validationPhoneNumber')
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
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
          this.validationPhoneNumber = validations.find(
            (validation) =>
              validation.type_validation == 'validationPhoneNumber' &&
              validation.status_validation
          )!;
          /**
           * Set Validation Pattern
           */
          if (this.validationPhoneNumber) {
            /**
             * Parse to String RegExp to RegExp
             */
            let validationPhoneNumberRegExp = new RegExp(
              this.validationPhoneNumber.pattern_validation
            );
            /**
             * Set Validators
             */
            this.officialForm.controls['phone_person'].setValidators([
              Validators.required,
              Validators.maxLength(13),
              Validators.pattern(validationPhoneNumberRegExp),
            ]);
            this.officialForm.controls['phone_job'].setValidators([
              Validators.maxLength(13),
              Validators.pattern(validationPhoneNumberRegExp),
            ]);
          } else {
            this.officialForm.controls['phone_person'].setValidators([
              Validators.required,
              Validators.maxLength(13),
            ]);
            this.officialForm.controls['phone_job'].setValidators([
              Validators.maxLength(13),
            ]);
          }
        }
      });
    /**
     * Validations
     */
    /**
     * Get the officials
     */
    this._officialService.officials$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((officials: Official[]) => {
        this.officials = officials;
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
    /**
     * Get the official
     */
    this._officialService.official$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((official: Official) => {
        /**
         * Open the drawer in case it is closed
         */
        this._officialListComponent.matDrawer.open();
        /**
         * Get the official
         */
        this.official = official;

        // User
        this._userService
          .byCompanyQueryRead(this.id_company, '*')
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((users: User[]) => {
            this.listUser = users;

            this.selectedUser = this.listUser.find(
              (item) => item.id_user == this.official.user.id_user.toString()
            )!;
          });

        // Area
        this._areaService
          .byCompanyQueryRead(this.id_company, '*')
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((areas: Area[]) => {
            this.listArea = areas;

            this.selectedArea = this.listArea.find(
              (item) => item.id_area == this.official.area.id_area.toString()
            )!;
          });

        // Position
        this._positionService
          .byCompanyQueryRead(this.id_company, '*')
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((positions: Position[]) => {
            this.listPosition = positions;

            this.selectedPosition = this.listPosition.find(
              (item) =>
                item.id_position ==
                this.official.position.id_position.toString()
            )!;
          });

        // Company
        this._companyService
          .queryRead('*')
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((companys: Company[]) => {
            this.listCompany = companys;

            this.selectedCompany = this.listCompany.find(
              (item) =>
                item.id_company ==
                this.official.user.company.id_company.toString()
            )!;
          });

        // TypeUser
        this._typeUserService
          .byCompanyQueryRead(this.id_company, '*')
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((type_users: TypeUser[]) => {
            this.listTypeUser = type_users;

            this.selectedTypeUser = this.listTypeUser.find(
              (item) =>
                item.id_type_user ==
                this.official.user.type_user.id_type_user.toString()
            )!;
          });

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
    this.officialForm.patchValue({
      ...this.official,

      id_user: this.official.user.id_user,
      id_type_user: this.official.user.type_user.id_type_user,
      name_user: this.official.user.name_user,
      password_user: this.aesDecrypt(this.official.user.password_user),
      avatar_user: this.official.user.avatar_user,
      status_user: this.official.user.status_user,

      id_company: this.official.user.company.id_company,

      id_person: this.official.user.person.id_person,
      dni_person: this.official.user.person.dni_person,
      name_person: this.official.user.person.name_person,
      last_name_person: this.official.user.person.last_name_person,
      address_person: this.official.user.person.address_person,
      phone_person: this.official.user.person.phone_person,

      id_academic: this.official.user.person.academic.id_academic,
      title_academic: this.official.user.person.academic.title_academic,
      abbreviation_academic:
        this.official.user.person.academic.abbreviation_academic,
      level_academic: this.official.user.person.academic.level_academic,

      id_job: this.official.user.person.job.id_job,
      name_job: this.official.user.person.job.name_job,
      address_job: this.official.user.person.job.address_job,
      phone_job: this.official.user.person.job.phone_job,
      position_job: this.official.user.person.job.position_job,
      id_area: this.official.area.id_area,
      id_position: this.official.position.id_position,
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
    return this._officialListComponent.matDrawer.close();
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
   * Update the official
   */
  updateOfficial(): void {
    /**
     * Get the official
     */
    const id_user_ = this.data.user.id_user;
    let official = this.officialForm.getRawValue();
    /**
     * Delete whitespace (trim() the atributes type string)
     */
    official = {
      ...official,
      id_user_: parseInt(id_user_),
      id_official: parseInt(official.id_official),
      company: {
        id_company: parseInt(official.id_company),
      },
      user: {
        id_user: parseInt(official.id_user),
        name_user: official.name_user.trim(),
        password_user: this.aesEncrypt(official.password_user.trim()),
        avatar_user: official.avatar_user.trim(),
        status_user: official.status_user,
        company: {
          id_company: parseInt(official.id_company),
        },
        person: {
          id_person: parseInt(official.id_person),
          academic: {
            id_academic: parseInt(official.id_academic),
            title_academic: official.title_academic.trim(),
            abbreviation_academic: official.abbreviation_academic.trim(),
            level_academic: official.level_academic.trim(),
          },
          job: {
            id_job: parseInt(official.id_job),
            name_job: official.name_job.trim(),
            address_job: official.address_job.trim(),
            phone_job: official.phone_job.trim(),
            position_job: official.position_job.trim(),
          },
          dni_person: official.dni_person.trim(),
          name_person: official.name_person.trim(),
          last_name_person: official.last_name_person.trim(),
          address_person: official.address_person.trim(),
          phone_person: official.phone_person.trim(),
        },
        type_user: {
          id_type_user: parseInt(official.id_type_user),
        },
      },
      area: {
        id_area: parseInt(official.id_area),
      },
      position: {
        id_position: parseInt(official.id_position),
      },
    };

    delete official.id_user;

    delete official.type_user;
    delete official.name_user;
    delete official.password_user;
    delete official.avatar_user;
    delete official.status_user;

    delete official.id_company;
    delete official.id_person;

    delete official.dni_person;
    delete official.name_person;
    delete official.last_name_person;
    delete official.address_person;
    delete official.phone_person;

    delete official.id_academic;
    delete official.title_academic;
    delete official.abbreviation_academic;
    delete official.level_academic;

    delete official.id_job;
    delete official.name_job;
    delete official.address_job;
    delete official.phone_job;
    delete official.position_job;

    delete official.id_profile;
    delete official.id_area;
    delete official.id_position;

    delete official.id_type_user;

    /**
     * Update
     */
    this._officialService
      .update(official)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_official: Official) => {
          if (_official) {
            this._notificationService.success(
              'Funcionario actualizada correctamente'
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
   * Delete the official
   */
  deleteOfficial(): void {
    this._angelConfirmationService
      .open({
        title: 'Eliminar funcionario',
        message:
          '¿Estás seguro de que deseas eliminar esta funcionario? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          /**
           * Get the current official's id
           */
          const id_user_ = this.data.user.id_user;
          const id_official = this.official.id_official;
          /**
           * Get the next/previous official's id
           */
          const currentIndex = this.officials.findIndex(
            (item) => item.id_official === id_official
          );

          const nextIndex =
            currentIndex +
            (currentIndex === this.officials.length - 1 ? -1 : 1);
          const nextId =
            this.officials.length === 1 &&
            this.officials[0].id_official === id_official
              ? null
              : this.officials[nextIndex].id_official;
          /**
           * Delete
           */
          this._officialService
            .delete(id_user_, id_official)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (response: boolean) => {
                if (response) {
                  /**
                   * Return if the official wasn't deleted...
                   */
                  this._notificationService.success(
                    'Funcionario eliminada correctamente'
                  );
                  /**
                   * Get the current activated route
                   */
                  let route = this._activatedRoute;
                  while (route.firstChild) {
                    route = route.firstChild;
                  }
                  /**
                   * Navigate to the next official if available
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
   * aesDecrypt
   * @param textEncrypted
   * @returns
   */
  aesDecrypt(textEncrypted: string) {
    return this._securityCap.aesDecrypt(textEncrypted);
  }
  /**
   * aesEncrypt
   * @param text
   * @returns
   */
  aesEncrypt(text: string) {
    return this._securityCap.aesEncrypt(text);
  }
  /**
   * Upload avatar
   *
   * @param fileList
   */
  uploadAvatar(fileList: FileList, user: User): void {
    // Return if canceled
    if (!fileList.length) {
      return;
    }

    const allowedTypes = ['image/jpeg', 'image/png'];
    const file = fileList[0];

    // Return if the file is not allowed
    if (!allowedTypes.includes(file.type)) {
      return;
    }

    // Upload the avatar
    this._officialService.uploadAvatar(user, file, this.data.user).subscribe();
    // Set Edit mode in true
    this.editMode = false;
  }

  /**
   * Remove the avatar
   */
  removeAvatar(user: User): void {
    this._officialService.removeAvatar(user, this.data.user).subscribe();
    // Set the file input value as null
    this._avatarFileInput.nativeElement.value = null;
    // Set Edit mode in true
    this.editMode = false;
  }
}
